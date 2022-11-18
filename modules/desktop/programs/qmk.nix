{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.qmk;
in
{
  options.modules.desktop.programs.qmk = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qmk
      qmk-udev-rules
    ];
  };
}
