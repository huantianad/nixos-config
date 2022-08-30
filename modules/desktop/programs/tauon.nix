{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.tauon;
in
{
  options.modules.desktop.programs.tauon = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.tauon.override {
        withDiscordRPC = true;
      })
    ];

    # networking.firewall = {
    #   allowedTCPPorts = [ 7590 ];
    # };
  };
}
