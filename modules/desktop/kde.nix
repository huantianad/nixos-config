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
    # TODO: #291913 should make it so that we can disable this
    services.xserver.enable = true;

    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.wayland.enable =
      config.modules.desktop.wayland.enable;

    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = [
      pkgs.kdePackages.elisa # Default KDE video player, use VLC instead
      pkgs.kdePackages.konsole # Use kitty instead
    ];

    environment.systemPackages = [
      pkgs.kdePackages.sddm-kcm # Settings menu for SDDM in KDE
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;
  };
}
