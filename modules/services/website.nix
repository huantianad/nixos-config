{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.website;
in
{
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
        file_server
      '';

      "www.${config.networking.domain}".extraConfig = ''
        redir https://${config.networking.domain}{uri}
      '';
    };
  };
}
