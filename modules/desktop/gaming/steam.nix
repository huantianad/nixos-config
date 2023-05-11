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

    programs.steam.package = pkgs.steam.override {
      # Workaround for steam beta GTK file picker issues, until #230375 is merged
      extraProfile = "XDG_DATA_DIRS=\"\$XDG_DATA_DIRS:/usr/share/\"";

      extraPkgs = pkgs: with pkgs; [
        gsettings-desktop-schemas
        hicolor-icon-theme
      ];
    };
  };
}
