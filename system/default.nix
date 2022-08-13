{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./nix.nix
    ./pipewire.nix
    ./user.nix
    ./x11.nix
  ];

  config = {
    networking.hostName = "huantian-desktop";

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";

    # Use the latest Linux kernel (non-LTS)
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Timezone and locale
    time.timeZone = "America/Phoenix";
    i18n.defaultLocale = "en_US.utf8";

    # Network Manager + wifi
    networking.networkmanager.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
