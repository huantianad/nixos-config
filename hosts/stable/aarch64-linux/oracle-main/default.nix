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
    host = "oracle-main";
    sshUser = "huantian";
    buildOn = "remote";
    substituteOnTarget = true;
    hermetic = false;
  };

  modules = {
    services = {
      grafana.enable = true;
      miniflux.enable = true;
      prometheus.enable = true;
      synapse.enable = true;
      website.enable = true;
    };
  };

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    configurationLimit = 5;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  boot.kernelParams = ["console=ttyS0,115200n8"];
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # Minecraft server
  networking.firewall.allowedTCPPorts = [25565];
  environment.systemPackages = with pkgs; [
    jre8
  ];
}
