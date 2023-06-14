{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.caddy;
in
{
  options.modules.services.caddy = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.caddy = {
      enable = true;
      logFormat = mkForce "level INFO";
      email = "davidtianli@gmail.com";
    };
  };
}
