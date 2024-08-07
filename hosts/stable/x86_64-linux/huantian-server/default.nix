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
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  modules = {
    services = {
      ddclient.enable = true;
      jellyfin.enable = true;
      navidrome.enable = true;
    };
  };

  services.logind.lidSwitch = "ignore";
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
