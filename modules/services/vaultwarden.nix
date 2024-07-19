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
    sops.secrets."vaultwarden" = {};
    sops.secrets."vaultwarden".owner = "vaultwarden";

    services.vaultwarden = {
      enable = true;

      environmentFile = "/run/secrets/vaultwarden";

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
