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
      # osu-lazer
      pkgs.my.r2modman
      (tetrio-desktop.override {
        withTetrioPlus = true;
      })
      melonDS
      my.tjaplayer3-f
    ];

    # Don't override `prismlauncher` as that makes Nix rebuild it
    environment.variables.PRISMLAUNCHER_JAVA_PATHS = with pkgs;
      lib.makeSearchPath "bin/java" [ jdk19 jdk11 ];
  };
}
