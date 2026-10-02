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
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
        pkgs.steam-play-none
      ];
    };

    environment.systemPackages = with pkgs; [
      steamcmd
    ];

    boot.kernelModules = ["ntsync"];

    hardware.steam-hardware.enable = true;
    boot.extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom=US
    '';
  };
}
