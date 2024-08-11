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

    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = true;

    specialisation.nvidiaBeta.configuration = {
      hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
      boot.loader.systemd-boot.sortKey = "nvidiaBeta";
    };

    environment.variables.MOZ_DISABLE_RDD_SANDBOX = "1";
    environment.variables.LIBVA_DRIVER_NAME = "nvidia";

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
  };
}
