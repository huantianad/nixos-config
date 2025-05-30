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
  cfg = config.modules.desktop.gaming;
in {
  options.modules.desktop.gaming = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cockatrice
      lutris
      # melonDS
      (prismlauncher.override {
        jdks = [jdk24];
      })
      # r2modman
      # ryujinx
      # scarab
      (tetrio-desktop.override {
        withTetrioPlus = true;
      })
      my.lr2oraja-endlessdream
    ];

    # Steam controller support
    hardware.steam-hardware.enable = true;
    # Joycon and Pro Controller support
    services.joycond.enable = true;
  };
}
