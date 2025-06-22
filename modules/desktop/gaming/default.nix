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
      (prismlauncher.override {
        jdks = [jdk24];
        glfw3-minecraft = glfw3-minecraft.overrideAttrs (old: {
          src = fetchFromGitHub {
            owner = "LWJGL-CI";
            repo = "GLFW";
            rev = "eb9046fc59e20f0d21aa3b4d1e879f789f6eccfa";
            hash = "sha256-KLjd371wc2IHpdviicNxWhNnz5lm3KoxE51hTdcyW00=";
          };
        });
      })
      # lutris
      # melonDS
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
