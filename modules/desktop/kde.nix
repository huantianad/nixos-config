{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.kde;
in
{
  options.modules.desktop.kde = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    environment.systemPackages = with pkgs; [
      libsForQt5.sddm-kcm # Settings menu for SDDM in KDE
    ];

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Configure keymap in X11
    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };

    services.xserver.desktopManager.plasma5.excludePackages = with pkgs; [
      elisa # Default KDE video player, use VLC instead
      kwrited # Use kate instead for my basic text editor
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;
  };
}
