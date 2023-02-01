{ pkgs, config, lib, ... }:

with builtins;
with lib;
{
  time.timeZone = mkDefault "America/Phoenix";
  i18n.defaultLocale = mkDefault "en_US.utf8";

  # Network Manager + wifi
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ pantum-driver ];

  # Steam controller support
  hardware.steam-hardware.enable = true;
  # Joycon and Pro Controller support
  services.joycond.enable = true;

  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };

  # Fix opening links in firefox from fhs with older nss, #160923, #197118
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # Use alternate xdg-open that works with xdg-portal
  environment.systemPackages = with pkgs; [
    my.flatpak-xdg-utils
  ];
}
