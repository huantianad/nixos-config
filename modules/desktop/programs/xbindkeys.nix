{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.xbindkeys;
in
{
  options.modules.desktop.programs.xbindkeys = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.xbindkeys ];

    home-manager.users.huantian.home.file = {
      # Use xbindkeys to fix play-pause button on keyboard
      ".xbindkeysrc/".text = ''
        "${pkgs.playerctl}/bin/playerctl play-pause"
          XF86AudioPlay
      '';
    };
  };
}
