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

  system.stateVersion = "21.11";

  _module.args.nixinate = {
    host = "oracle-micro2";
    sshUser = "huantian";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  modules = {
    services = {
      deluge.enable = true;
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.efiSysMountPoint = "/boot";
    efi.canTouchEfiVariables = true;
  };
  boot.kernelParams = ["console=ttyS0,115200n8"];
  boot.kernelPackages = pkgs.linuxPackages_6_12;
}
