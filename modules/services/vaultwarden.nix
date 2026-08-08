{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.vaultwarden;
in {
  options.modules.services.vaultwarden = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    sops.secrets.vaultwarden.owner = config.users.users.vaultwarden.name;
    sops.secrets.vaultwarden.group = config.users.users.vaultwarden.group;

    services.vaultwarden = {
      enable = true;

      environmentFile = config.sops.secrets.vaultwarden.path;

      config = {
        webVaultEnabled = true;
        websocketEnabled = true;
        signupsVerify = false;
        signupsAllowed = false;
        domain = "https://vw.huantian.dev";
        rocketPort = 8812;
        pushEnabled = true;
      };
    };

    modules.services.caddy.enable = true;

    services.caddy = {
      virtualHosts."vw.huantian.dev".extraConfig = ''
        encode zstd gzip

        header {
          # Enable HTTP Strict Transport Security (HSTS)
          Strict-Transport-Security "max-age=31536000;"
          # Disable cross-site filter (XSS)
          X-XSS-Protection "0"
          # Disallow the site to be rendered within a frame (clickjacking protection)
          X-Frame-Options "DENY"
          # Prevent search engines from indexing (optional)
          X-Robots-Tag "noindex, nofollow"
          # Disallow sniffing of X-Content-Type-Options
          X-Content-Type-Options "nosniff"
          # Server name removing
          -Server
          # Remove X-Powered-By though this shouldn't be an issue, better opsec to remove
          -X-Powered-By
          # Remove Last-Modified because etag is the same and is as effective
          -Last-Modified
        }

        reverse_proxy http://localhost:8812 {
          # Send the true remote IP to Rocket, so that vaultwarden can put this in the
          # log, so that fail2ban can ban the correct IP.
          header_up X-Real-IP {http.request.header.Cf-Connecting-Ip}
        }
      '';
    };
  };
}
