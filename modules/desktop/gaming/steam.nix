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

    nixpkgs.overlays = [
      (self: super: {
        steam = super.steam.override {
          extraPkgs = pkgs: [
            # I think I added these libraries for Demoncrawl
            pkgs.libssh
            pkgs.brotli
          ];
          extraProfile = ''
            # Fix "No GSettings schemas are installed on the system"
            export GSETTINGS_SCHEMA_DIR=${pkgs.glib.getSchemaPath pkgs.gtk3}
          '';
        };
      })
    ];
  };
}
