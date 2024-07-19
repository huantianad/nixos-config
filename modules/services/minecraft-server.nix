{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.minecraft-server;
in {
  options.modules.services.minecraft-server = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      declarative = true;
      openFirewall = true;
      eula = true;
      serverProperties = {
        motd = "hihi";
        enforce-secure-profile = false;
      };
    };
  };
}
