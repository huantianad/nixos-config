{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.wayland;
in
{
  options.modules.desktop.wayland = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
