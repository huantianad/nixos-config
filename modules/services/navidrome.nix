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
  cfg = config.modules.services.navidrome;
in {
  options.modules.services.navidrome = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      settings = {
        MusicFolder = "/mnt/music";
      };
    };

    modules.services.caddy.enable = true;

    services.caddy = {
      virtualHosts."navidrome.huantian.dev".extraConfig = ''
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

        reverse_proxy @notblacklisted http://localhost:${toString config.services.navidrome.settings.Port}
      '';
    };
  };
}
