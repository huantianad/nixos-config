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
    services.xserver.enable = ! config.modules.desktop.wayland.enable;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = config.modules.desktop.wayland.enable;
      wayland.compositor = "kwin";
    };

    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = [
      pkgs.kdePackages.elisa # Default KDE video player, use VLC instead
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;
  };
}
