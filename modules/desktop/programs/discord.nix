{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.discord;
in
{
  options.modules.desktop.programs.discord = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.discord.override { withOpenASAR = true; })
    ];
  };
}
