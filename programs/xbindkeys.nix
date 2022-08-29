{ config, pkgs, lib, inputs, ... }:

{
  config = {
    environment.systemPackages = [ pkgs.xbindkeys ];

    systemd.services."xbindkeys" = {
      description = "xbindkeys";
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "xsession.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys --nodaemon -f /home/huantian/.xbindkeysrc";
        User = "huantian";
        Group = "users";
      };
    };

    home-manager.users.huantian.home.file = {
      # ".config/autostart/xbindkeys.desktop".text = ''
      #   [Desktop Entry]
      #   Encoding=UTF-8
      #   Version=${pkgs.xbindkeys.version}
      #   Name=xbindkeys
      #   Comment=Start xbindkeys service.
      #   Exec=
      #   StartupNotify=false
      #   Terminal=false
      # '';

      ".xbindkeysrc/".text = ''
        "${pkgs.playerctl}/bin/playerctl play-pause"
          XF86AudioPlay
      '';
    };
  };
}
