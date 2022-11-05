{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.framework
    ../server.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.05";

  _module.args.nixinate = {
    host = "oracle-micro2";
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
    };

    shell = {
    };
  };
}
