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
      cockatrice
      lutris
      melonDS
      prismlauncher
      r2modman
      ryujinx
      scarab
      (tetrio-desktop.override {
        withTetrioPlus = true;
      })
    ];

    # Don't override `prismlauncher` as that makes Nix rebuild it
    environment.variables.PRISMLAUNCHER_JAVA_PATHS = with pkgs;
      lib.makeSearchPath "bin/java" [ jdk19 jdk11 ];

    # Steam controller support
    hardware.steam-hardware.enable = true;
    # Joycon and Pro Controller support
    services.joycond.enable = true;
  };
}
