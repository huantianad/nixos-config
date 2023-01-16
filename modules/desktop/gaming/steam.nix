{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.steam;
in
{
  options.modules.desktop.gaming.steam = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    environment.systemPackages = with pkgs; [
      steamPackages.steamcmd
    ];

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";

    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          # GTK filepicker
          gsettings-desktop-schemas
          hicolor-icon-theme
        ];
      };
    };
  };
}
