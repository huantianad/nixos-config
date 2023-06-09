{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming;
in
{
  options.modules.desktop.gaming = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      prismlauncher
      scarab
      cockatrice
      airshipper
      osu-lazer-bin
      melonDS
      (tetrio-desktop.override {
        withTetrioPlus = true;
      })

      # my.tjaplayer3-f
      # my.r2modman
    ];

    # Don't override `prismlauncher` as that makes Nix rebuild it
    environment.variables.PRISMLAUNCHER_JAVA_PATHS = with pkgs;
      lib.makeSearchPath "bin/java" [ jdk19 jdk11 ];
  };
}
