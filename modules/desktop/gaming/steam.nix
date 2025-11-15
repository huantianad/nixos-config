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
  cfg = config.modules.desktop.gaming.steam;
in {
  options.modules.desktop.gaming.steam = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.remotePlay.openFirewall = true;
    programs.steam.extraCompatPackages = [
      pkgs.proton-ge-bin
    ];

    environment.systemPackages = with pkgs; [
      steamcmd
    ];
  };
}
