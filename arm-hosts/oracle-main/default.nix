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
}
