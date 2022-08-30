{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.kde;
in
{
  options.modules.desktop.kde = {
    enable = mkBoolOpt false;
    latte-dock.enable = mkBoolOpt false;
    autoLogin = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    # latte-dock for kde
    environment.systemPackages = mkIf cfg.latte-dock.enable [ pkgs.latte-dock ];

    # Enable automatic login for the user.
    services.xserver.displayManager.autoLogin.enable = cfg.autoLogin;
    services.xserver.displayManager.autoLogin.user = "huantian";

    nixpkgs.config.librewolf.enablePlasmaBrowserIntegration = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Configure keymap in X11
    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };

    services.xserver.desktopManager.plasma5.excludePackages = with pkgs; [
      elisa # Default KDE video player, use VLC instead
    ];
  };
}
