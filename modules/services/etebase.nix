{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.etebase;
in
{
  options.modules.services.etebase = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.etebase-server = {
      enable = true;
      port = 8007;
      settings = {
        allowed_hosts.allowed_host1 = "etebase.huantian.dev";
      };
    };

    modules.services.caddy.enable = true;

    services.caddy = {
      virtualHosts.${config.services.etebase-server.settings.allowed_hosts.allowed_host1}.extraConfig = ''
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

        reverse_proxy http://localhost:${toString config.services.etebase-server.port}
      '';
    };
  };
}
