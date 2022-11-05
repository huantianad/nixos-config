{ pkgs, config, lib, ... }:

with builtins;
with lib;
{
  ## Location config -- since Toronto is my 127.0.0.1
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
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };
}
