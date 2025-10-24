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

    environment.sessionVariables.XAUTHORITY = "$XDG_CONFIG_HOME/sddm/Xauthority";

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = config.modules.desktop.wayland.enable;
      wayland.compositor = "kwin";
      settings = {
        X11.UserAuthFile = ".local/share/sddm/Xauthority";
      };
    };

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
