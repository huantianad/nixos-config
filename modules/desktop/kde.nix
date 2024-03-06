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

    services.xserver.displayManager.defaultSession = mkIf
      config.modules.desktop.wayland.enable "plasmawayland";
    services.xserver.displayManager.sddm.wayland.enable =
      config.modules.desktop.wayland.enable;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    environment.plasma5.excludePackages = with pkgs; [
      elisa # Default KDE video player, use VLC instead
      kwrited # Use kate instead for my basic text editor
      konsole # Use kitty instead
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;
  };
}
