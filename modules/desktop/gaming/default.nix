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
          prePatch = let
            minecraftPatches = fetchFromGitHub {
              owner = "BoyOrigin";
              repo = "glfw-wayland";
              rev = "f62b4ae8f93149fd754cadecd51d8b1a07d20522";
              hash = "sha256-kvWP34rOD4HSTvnKb33nvVquTGZoqP8/l+8XQ0h3b7Y=";
            };
          in ''
            patches+=(${minecraftPatches}/patches/0005-Avoid-error-on-startup.patch)
          '';
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
