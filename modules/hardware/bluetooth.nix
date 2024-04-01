{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
  };
}
