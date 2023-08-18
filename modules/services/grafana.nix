{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.grafana;
in
{
  options.modules.services.grafana = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      domain = "grafana.huantian.dev";
      port = 2342;
      addr = "127.0.0.1";
    };

    modules.services.caddy.enable = true;

    services.caddy = {
      virtualHosts.${config.services.grafana.domain}.extraConfig = ''
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

        reverse_proxy http://localhost:${toString config.services.grafana.port}
      '';
    };
  };
}
