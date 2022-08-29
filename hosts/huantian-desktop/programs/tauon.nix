{ config, pkgs, lib, inputs, ... }:

{
  config = {
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
