{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.kitty;
in
{
  options.modules.desktop.programs.kitty = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.huantian.programs.kitty = {
      enable = true;
      font.name = "MesloLGS NF";
    };
  };
}
