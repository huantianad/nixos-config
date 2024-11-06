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

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # write extra config
      extraConfig.pipewire = {
        "99-lowlatency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [44100 48000 88200 96000 176400 192000 352800 384000];
          };

          "context.modules" = [
            {
              name = "libpipewire-module-rtkit";
              flags = ["ifexists" "nofail"];
              args = {
                "nice.level" = -20;
                "rt.prio" = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
            }
          ];
        };
      };

      wireplumber = {
        enable = true;
        extraConfig."51-alsa-lowlatency"."monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "~alsa_output.*";
              }
            ];
            actions = {
              update-props = {
                "api.alsa.period-num" = 1028;
                "api.alsa.period-size" = 64;
                # "api.alsa.headroom" = 0;
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
      };
    };
  };
}
