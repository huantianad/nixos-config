{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.website;
in {
  options.modules.services.website = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.services.caddy.enable = true;

    services.caddy.virtualHosts = {
      "${config.networking.domain}".extraConfig = ''
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
          # Server name removing
          -Server

          Referrer-Policy: no-referrer
          Content-Security-Policy "default-src 'none'; manifest-src 'self'; font-src 'self'; img-src 'self'; style-src 'self'; form-action 'none'; frame-ancestors 'none'; base-uri 'none'"
        }

        root * /var/www/huantian.dev/
        file_server {
          # If we visit /404.html directly we receive a 404 response, and not a 200.
          hide 404.html
        }

        handle_errors {
          @404 {
            expression {http.error.status_code} == 404
          }
          # For 404 errors show custom 404 error page
          handle @404 {
            rewrite * /404.html
            file_server
          }
          # For other errors respond with generic message
          handle {
            respond "{http.error.status_code} {http.error.status_text}" {http.error.status_code}
          }
        }
      '';

      # Redirect www.huantian.dev -> huantian.dev
      "www.${config.networking.domain}".extraConfig = ''
        redir https://${config.networking.domain}{uri}
      '';
    };
  };
}
