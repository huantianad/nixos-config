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

  # Tell SSH to use ksshaskpass even when in terminal
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  # Fix tauri apps not displaying correctly, ie for cinny
  # see https://github.com/tauri-apps/tauri/issues/4315#issuecomment-1207755694
  environment.sessionVariables.WEBKIT_DISABLE_COMPOSITING_MODE = "1";
}
