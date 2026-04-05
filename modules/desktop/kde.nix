{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.kde;
in {
  options.modules.desktop.kde = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.enable = ! config.modules.desktop.wayland.enable;

    environment.sessionVariables.KWIN_USE_OVERLAYS = "1";

    services.displayManager.plasma-login-manager.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = [
      # Default KDE video player, use VLC/mpv instead
      pkgs.kdePackages.elisa
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = false;
    programs.kde-pim.enable = false;
  };
}
