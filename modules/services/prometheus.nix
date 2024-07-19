{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.prometheus;
in {
  options.modules.services.prometheus = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = 9001;

      ruleFiles = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/matrix-org/synapse/ac7e5683d6c8f7cbe835371a05587e7d739b9854/contrib/prometheus/synapse-v2.rules";
          hash = "sha256-WldlBdCMzul49OlFhJMsrx4MYFakHTa36Y9HnV22EwI=";
        })
      ];

      scrapeConfigs = [
        {
          job_name = "oracle-main";
          static_configs = [
            {
              targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
            }
          ];
        }
        {
          job_name = "oracle-main-caddy";
          static_configs = [
            {
              targets = ["127.0.0.1:2019"];
            }
          ];
        }
        {
          job_name = "miniflux";
          static_configs = [
            {
              targets = ["127.0.0.1:8877"];
            }
          ];
        }
        {
          job_name = "synapse";
          metrics_path = "/_synapse/metrics";
          static_configs = [
            {
              targets = ["127.0.0.1:9003"];
            }
          ];
        }
      ];

      exporters = {
        node = {
          enable = true;
          enabledCollectors = ["systemd"];
          port = 9002;
        };
      };
    };
  };
}
