{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.nginx;
in
{
  options.modules.services.nginx = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    security.acme.acceptTerms = true;
    security.acme.defaults.email = "davidtianli@gmail.com";
    security.acme.certs."huantian.dev"= {
      extraDomainNames = [ "www.huantian.dev" ];
    };

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."huantian.dev" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/huantian.dev/";
      };
    };
  };
}
