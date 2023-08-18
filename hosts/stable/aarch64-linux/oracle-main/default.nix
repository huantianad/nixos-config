{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../../server.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "21.11";

  _module.args.nixinate = {
    host = "oracle-main";
    sshUser = "huantian";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  modules = {
    services = {
      grafana.enable = true;
      synapse.enable = true;
      website.enable = true;
      miniflux.enable = true;
      prometheus.enable = true;
    };
  };

  # Minecraft server
  networking.firewall.allowedTCPPorts = [ 25565 25566 ];
  # Plasmo voice
  networking.firewall.allowedUDPPorts = [ 25565 25566 ];
  environment.systemPackages = with pkgs; [
    jdk17_headless
    # jre8
  ];
}
