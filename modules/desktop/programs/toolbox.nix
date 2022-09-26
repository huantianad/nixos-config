{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.programs.jetbrains-toolbox;
in
{
  options.modules.desktop.programs.jetbrains-toolbox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.my.jetbrains-toolbox ];
  };
}
