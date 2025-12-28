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
  cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.nvidia = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = false;
      open = true;
      videoAcceleration = true;
    };

    boot.kernelParams = ["nvidia-drm.modeset=1" "nvidia-drm.fbdev=1"];
    boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.variables.MOZ_DISABLE_RDD_SANDBOX = "1";
    environment.variables.LIBVA_DRIVER_NAME = "nvidia";
  };
}
