{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming;
in
{
  options.modules.desktop.gaming = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      polymc
      scarab
      cockatrice
      airshipper
      tetrio-desktop
    ];
  };
}
