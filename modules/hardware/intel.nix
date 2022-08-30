{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.intel;
in
{
  options.modules.hardware.intel = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "intel" ];
  };
}
