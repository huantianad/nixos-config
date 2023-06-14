{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.services.synapse;
  fqdn = "matrix.huantian.dev";
in
{
  options.modules.services.synapse = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.postgresql.enable = true;
    services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';

    modules.services.caddy.enable = true;

    services.caddy.virtualHosts = {
      # This host section can be placed on a different host than the rest,
      # i.e. to delegate from the host being accessible as ${config.networking.domain}
      # to another host actually running the Matrix homeserver.
      "${config.networking.domain}".extraConfig =
        let
          # use 443 instead of the default 8448 port to unite
          # the client-server and server-server port for simplicity
          server = {
            "m.server" = "${fqdn}:443";
          };
          client = {
            "m.homeserver" = { "base_url" = "https://${fqdn}"; };
            "m.identity_server" = { "base_url" = "https://vector.im"; };
          };
        in
        ''
          handle_path /.well-known/matrix/* {
            header {
              Content-Type "application/json"
            }

            handle /server {
              respond `${builtins.toJSON server}`
            }

            handle /client {
              header {
                # ACAO required to allow element-web on any URL to request this json file
                Access-Control-Allow-Origin "*"
              }
              respond `${builtins.toJSON client}`
            }
          }
        '';

      "${fqdn}".extraConfig = ''
        route {
          reverse_proxy /_matrix/* localhost:8008
          respond 404
        }
      '';
    };

    services.matrix-synapse = {
      enable = true;
      settings = {
        server_name = config.networking.domain;
        listeners = [{
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = false;
            }
          ];
        }];
      };
    };
  };
}
