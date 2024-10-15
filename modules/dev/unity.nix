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
  cfg = config.modules.dev.unity;
in {
  options.modules.dev.unity = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.unityhub.override {
        extraPkgs = pkgs:
          with pkgs; [
            # Needed for Rhythm Doctor
            libogg
          ];
      })
    ];
  };
}
