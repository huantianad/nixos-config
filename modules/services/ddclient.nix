{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.ddclient;
in {
  options.modules.services.ddclient = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    sops.secrets."ddclient" = {
      restartUnits = ["ddclient.service"];
    };

    services.ddclient = {
      enable = true;
      use = "web, web=https://api.ipify.org/";
      protocol = "cloudflare";
      zone = "huantian.dev";
      username = "token";
      passwordFile = "/run/credentials/ddclient.service/credentials";
      domains = ["old.huantian.dev"];
    };

    systemd.services.ddclient.serviceConfig.LoadCredential = "credentials:${config.sops.secrets."ddclient".path}";
  };
}
