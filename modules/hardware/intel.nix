{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.intel;
in {
  options.modules.hardware.intel = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.variables.LIBVA_DRIVER_NAME = "iHD";

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
        intel-ocl
      ];
    };
  };
}
