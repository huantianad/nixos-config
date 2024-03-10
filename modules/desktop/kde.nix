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

    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.wayland.enable =
      config.modules.desktop.wayland.enable;

    services.xserver.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa # Default KDE video player, use VLC instead
      konsole # Use kitty instead
    ];

    environment.systemPackages = [
      pkgs.kdePackages.sddm-kcm # Settings menu for SDDM in KDE
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;
  };
}
