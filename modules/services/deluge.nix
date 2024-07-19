{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.deluge;
in {
  options.modules.services.deluge = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.deluge.enable = true;
  };
}
