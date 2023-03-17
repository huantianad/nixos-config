{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../hosts/server.nix
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
      nginx.enable = true;
      synapse.enable = true;
    };
  };

  # Minecraft server
  programs.tmux.enable = true;
  networking.firewall.allowedTCPPorts = [ 25565 ];
  environment.systemPackages = with pkgs; [
    # jdk17_headless decursio
    jre8
  ];
}
