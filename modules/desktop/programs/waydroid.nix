{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.waydroid;
in
{
  options.modules.desktop.programs.waydroid = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    virtualisation = {
      waydroid.enable = true;
      lxd.enable = true;
    };
  };
}
