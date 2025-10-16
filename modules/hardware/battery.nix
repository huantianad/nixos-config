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
  cfg = config.modules.hardware.battery;
in {
  options.modules.hardware.battery = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # Some battery life tuning
    services.tlp.enable = false;
    services.tlp.settings = {
      PCIE_ASPM_ON_BAT = "powersupersave";

      INTEL_GPU_MIN_FREQ_ON_BAT = 100;
      INTEL_GPU_MAX_FREQ_ON_BAT = 800;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 1000;
      INTEL_GPU_MIN_FREQ_ON_AC = 100;
      INTEL_GPU_MAX_FREQ_ON_AC = 1300;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1300;

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 100;

      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      SOUND_POWER_SAVE_ON_AC = 0;
    };
    # Disable power-profiles-daemon as it conflicts with tlp
    services.power-profiles-daemon.enable = false;
    # Thermal config
    services.thermald.enable = false;

    services.tuned.enable = true;
  };
}
