{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.grafana;
in {
  options.modules.services.grafana = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings.server = {
        domain = "grafana.huantian.dev";
        # Use root_url instead of domain, since the default adds the port.
        root_url = "https://grafana.huantian.dev/";
        enforce_domain = true;
        http_port = 2342;
        http_addr = "127.0.0.1";
        enable_gzip = false; # Use caddy compression
      };
    };

    modules.services.caddy.enable = true;

    services.caddy = {
      virtualHosts.${config.services.grafana.settings.server.domain}.extraConfig = ''
        encode zstd gzip

        header {
          # Enable HTTP Strict Transport Security (HSTS)
          Strict-Transport-Security "max-age=31536000;"
          # Enable cross-site filter (XSS) and tell browser to block detected attacks
          X-XSS-Protection "1; mode=block"
          # Disallow the site to be rendered within a frame (clickjacking protection)
          X-Frame-Options "DENY"
          # Avoid MIME type sniffing
          X-Content-Type-Options "nosniff"
          # Prevent search engines from indexing (optional)
          X-Robots-Tag "none"
          # Server name removing
          -Server
        }

        @notblacklisted {
          not {
            path /metrics*
          }
        }

        reverse_proxy @notblacklisted http://localhost:${toString config.services.grafana.settings.server.http_port}
      '';
    };
  };
}
