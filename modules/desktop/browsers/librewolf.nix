{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.librewolf;
in
{
  options.modules.desktop.browsers.librewolf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.config.librewolf.enablePlasmaBrowserIntegration =
      config.modules.desktop.kde.enable;

    environment.systemPackages =
      if config.modules.desktop.wayland.enable
      then [ pkgs.librewolf-wayland ]
      else [ pkgs.librewolf ];
  };
}
