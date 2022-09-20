{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.programs.butler;
in
{
  options.modules.desktop.programs.butler = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ (pkgs.callPackage (import ./butler) { }) ];
  };
}
