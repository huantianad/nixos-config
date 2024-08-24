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
  cfg = config.modules.hardware.pipewire;
in {
  options.modules.hardware.pipewire = {
    enable = mkBoolOpt false;
  };

  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;

      wireplumber.enable = true;

      lowLatency = {
        enable = true;
        quantum = 64;
        rate = 48000;
      };

      extraConfig.pipewire = {
        "99-z-clock-rate" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [44100 48000 88200 96000 176400 192000];

            "default.clock.quantum" = 64;
            "default.clock.min-quantum" = 64;
            "default.clock.max-quantum" = 1024;
          };
        };
      };
    };
  };
}
