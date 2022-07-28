{ config, pkgs, lib, inputs, ... }:

{
  config = {
    environment.systemPackages = [ pkgs.xbindkeys ];

    home-manager.users.huantian.home.file = {
      ".config/autostart/xbindkeys.desktop".text = ''
        [Desktop Entry]
        Encoding=UTF-8
        Version=${pkgs.xbindkeys.version}
        Name=xbindkeys
        Comment=Start xbindkeys service.
        Exec=${pkgs.xbindkeys}/bin/xbindkeys -f /home/huantian/.xbindkeysrc
        StartupNotify=false
        Terminal=false
      '';

      ".xbindkeysrc/".text = ''
        "${pkgs.playerctl}/bin/playerctl play-pause"
          XF86AudioPlay
      '';
    };
  };
}