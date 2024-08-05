{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.caddy;
in {
  options.modules.services.caddy = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [80 443];

    # TODO: Setup custom error code handling pages
    services.caddy = {
      enable = true;
      logFormat = mkForce "level INFO";
      email = "davidtianli@gmail.com";
      globalConfig = ''
        servers {
          metrics
          trusted_proxies static private_ranges 173.245.48.0/20 103.21.244.0/22 103.22.200.0/22 103.31.4.0/22 141.101.64.0/18 108.162.192.0/18 190.93.240.0/20 188.114.96.0/20 197.234.240.0/22 198.41.128.0/17 162.158.0.0/15 104.16.0.0/13 104.24.0.0/14 172.64.0.0/13 131.0.72.0/22
        }
      '';
    };

    services.promtail = {
      enable = config.modules.services.loki.enable;
      configuration = {
        server = {
          http_listen_port = 28183;
          grpc_listen_port = 0;
        };

        clients = [
          {
            url = "http://127.0.0.1:3100/loki/api/v1/push";
          }
        ];

        scrape_configs = [
          {
            job_name = "caddy_access_log";

            static_configs = [
              {
                targets = ["localhost"];
                labels = {
                  job = "caddy_access_log";
                  host = "huantian.dev";
                  agent = "caddy-promtail";
                  __path__ = "/var/log/caddy/*.log";
                };
              }
            ];

            pipeline_stages = [
              {
                json.expressions.client_ip = "request.client_ip";
              }
              {
                geoip = {
                  db = "/var/db/GeoLite2-City.mmdb";
                  source = "client_ip";
                  db_type = "city";
                };
              }
            ];
          }
        ];
      };
    };
  };
}
