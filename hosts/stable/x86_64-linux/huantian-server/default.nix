{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../../server.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.05";

  _module.args.nixinate = {
    host = "huantian-server";
    sshUser = "huantian";
    buildOn = "local";
    substituteOnTarget = true;
    hermetic = false;
  };

  modules = {
    services = {
    };
  };

  services.logind.lidSwitch = "ignore";
}
