{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../server.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "21.11";

  _module.args.nixinate = {
    host = "oracle-micro1";
    sshUser = "huantian";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  modules = {
    desktop = {
    };

    dev = {
    };

    editors = {
    };

    hardware = {
    };

    services = {
      vaultwarden.enable = true;
    };

    shell = {
    };
  };
}
