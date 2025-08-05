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
    boot.kernelParams = ["preempt=full"];
    security.rtkit.enable = true;
    security.pam.loginLimits = [
      {
        domain = "@pipewire";
        type = "-";
        item = "rtprio";
        value = "95";
      }
      {
        domain = "@pipewire";
        type = "-";
        item = "nice";
        value = "-19";
      }
      {
        domain = "@pipewire";
        type = "-";
        item = "memlock";
        value = "4194304";
      }
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      extraConfig.pipewire = {
        "99-lowlatency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [44100 48000 88200 96000 176400 192000 352800 384000];
          };

          "context.modules" = [
            {
              name = "libpipewire-module-rt";
              args = {
                "nice.level" = -19;
                "rt.prio" = 95;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
            }
          ];
        };
      };

      extraConfig.pipewire-pulse = {
        "99-lowlatency-pulse" = {
          "pulse.properties" = {
            "pulse.min.req" = "64/48000";
            "pulse.min.frag" = "64/48000";
            "pulse.min.quantum" = "64/48000";
          };
        };
      };

      wireplumber = {
        enable = true;
        extraConfig."51-alsa-lowlatency"."monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "~alsa_output.usb*";
              }
            ];
            actions = {
              update-props = {
                # "api.alsa.period-num" = 2;
                # "api.alsa.period-size" = 64;
                "api.alsa.headroom" = 0;
              };
            };
          }
        ];
      };
    };
  };
}
