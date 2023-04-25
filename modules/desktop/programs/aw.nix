{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.programs.aw;
in
{
  options.modules.desktop.programs.aw = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.aw.legacyPackages.${pkgs.system}.activitywatch
      inputs.aw-watcher-custom.packages.${pkgs.system}.default
    ];
  };
}
