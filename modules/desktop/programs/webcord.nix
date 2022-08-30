{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.webcord;
in
{
  options.modules.desktop.programs.webcord = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.webcord.packages.${pkgs.system}.default
    ];
  };
}
