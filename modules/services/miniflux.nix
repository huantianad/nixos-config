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
  cfg = config.modules.services.miniflux;
in {
  options.modules.services.miniflux = {
    enable = mkBoolOpt false;
  };

  imports = [inputs.minifluxng.nixosModules.minifluxng];

  config = mkIf cfg.enable {
    services.minifluxng = {
      enable = true;
      listenAddress = "127.0.0.1:8877";
      baseUrl = "https://miniflux.huantian.dev/";
      enableMetrics = true;
    };

    modules.services.caddy.enable = true;

    services.caddy = {
      virtualHosts."miniflux.huantian.dev".extraConfig = ''
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

        reverse_proxy @notblacklisted http://localhost:8877
      '';
    };
  };
}
