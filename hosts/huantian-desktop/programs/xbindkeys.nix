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
      ".xbindkeysrc/".text = ''
        "${pkgs.playerctl}/bin/playerctl play-pause"
          XF86AudioPlay
      '';
    };
  };
}