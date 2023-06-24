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
      synapse.enable = true;
      website.enable = true;
    };
  };

  # Temp disable this cus it's broken
  documentation.nixos.enable = false;

  # Minecraft server
  networking.firewall.allowedTCPPorts = [ 25565 25566 ];
  # Plasmo voice
  networking.firewall.allowedUDPPorts = [ 25565 25566 ];
  environment.systemPackages = with pkgs; [
    jdk17_headless
    # jre8
  ];
}
