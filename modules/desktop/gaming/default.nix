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
            repo = "glfw";
            rev = "63e379983175bff6d66d1f5443d137167be26e4a";
            hash = "sha256-reaGIASszkBckm6JzhkdM+6Ktd96bma8GRVlZ8XXwL0=";
          };
        });
      })
      # lutris
      # melonDS
      # r2modman
      # ryujinx
      # scarab
      # (tetrio-desktop.override {
      #   withTetrioPlus = true;
      # })
      # my.lr2oraja-endlessdream
    ];

    # Steam controller support
    hardware.steam-hardware.enable = true;
    # Joycon and Pro Controller support
    services.joycond.enable = false;
  };
}
