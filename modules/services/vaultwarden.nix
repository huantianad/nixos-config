{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.vaultwarden;
in
{
  options.modules.services.vaultwarden = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;

      config = {
        webVaultEnabled = true;
        logFile = "/var/log/vaultwarden";
        websocketEnable = true;
        ## websocketAddress = "0.0.0.0";
        ## websocketPort = 3012;
        signupsVerify = false;
        signupsAllowed = false;
        domain = "https://vw.huantian.dev";
        rocketPort = 8812;
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.caddy = {
      enable = true;
      extraConfig = ''
      https://vw.huantian.dev {
        tls davidtianli@gmail.com
        encode gzip

        header {
          # Enable HTTP Strict Transport Security (HSTS)
          Strict-Transport-Security "max-age=31536000;"
          # Enable cross-site filter (XSS) and tell browser to block detected attacks
          X-XSS-Protection "1; mode=block"
          # Disallow the site to be rendered within a frame (clickjacking protection)
          X-Frame-Options "DENY"
          # Prevent search engines from indexing (optional)
          X-Robots-Tag "none"
          # Server name removing
          -Server
        }

        # Notifications redirected to the websockets server
        reverse_proxy /notifications/hub http://localhost:3012

        # Proxy everything else to Rocket
        reverse_proxy http://localhost:8812 {
          # Send the true remote IP to Rocket, so that vaultwarden can put this in the
          # log, so that fail2ban can ban the correct IP.
          header_up X-Real-IP {remote_host}
        }
      }
      '';
    };
  };
}