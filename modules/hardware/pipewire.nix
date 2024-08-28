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

  quantum = 64;
  rate = 48000;
  qr = "${toString quantum}/${toString rate}";
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
      # jack.enable = true;

      # write extra config
      extraConfig.pipewire = {
        "99-lowlatency" = {
          "context.properties" = {
            "default.clock.rate" = rate;
            "default.clock.allowed-rates" = [44100 48000 88200 96000 176400 192000];

            "default.clock.quantum" = quantum;
            "default.clock.min-quantum" = quantum;
            "default.clock.max-quantum" = quantum;

            # This is because quantum is scaled down by factor of 2 when using 44100khz
            # and we don't want our quantum to actually go that low
            "default.clock.quantum-floor" = quantum;
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
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                # "server.address" = ["unix:native"];

                # playback latency
                "pulse.min.req" = qr;
                "pulse.default.req" = qr;

                # recording latency
                "pulse.min.frag" = qr;
                "pulse.default.frag" = qr;
                # "pulse.max.frag" = qr;

                # data stored on server
                "pulse.default.tlength" = "6000/${toString rate}";

                # buffer size in samples, calculated from req/tlength
                "pulse.min.quantum" = qr;
                # "pulse.max.quantum" = qr;
              };
            }
          ];

          "stream.properties" = {
            "node.latency" = qr;
            "resample.quality" = 1;
          };
        };
      };

      wireplumber = {
        enable = true;
        extraConfig.main."99-alsa-lowlatency" = ''
          alsa_monitor.rules = {
            {
              matches = {{{ "node.name", "matches", "alsa_output.*" }}};
              apply_properties = {
                -- ["audio.format"] = "S32LE",
                -- ["audio.rate"] = "${toString (rate * 2)}", -- for USB soundcards it should be twice your desired rate
                ["api.alsa.period-size"] = 2, -- defaults to 1024, tweak by trial-and-error
                -- ["api.alsa.period-num"] = 2,
                -- ["api.alsa.headroom"] = 0
              },
            },
          }
        '';
      };
    };
  };
}
