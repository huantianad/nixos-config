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
        jdks = [jdk25];
        glfw3-minecraft = glfw3.overrideAttrs (old: {
          src = fetchFromGitHub {
            owner = "LWJGL-CI";
            repo = "GLFW";
            rev = "c1636b906be78a9f59ad435297c6b9126e0cc10c";
            hash = "sha256-WZWYCL3rP5OJxMDA+0747+XNvaEENTc5muG0qFZuE4c=";
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
      # my.lr2oraja-endlessdream
    ];

    # Steam controller support
    hardware.steam-hardware.enable = true;
    # Joycon and Pro Controller support
    services.joycond.enable = true;
  };
}
