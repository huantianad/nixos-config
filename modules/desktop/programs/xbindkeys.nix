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

    systemd.services."xbindkeys" = {
      description = "xbindkeys";
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "xsession.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys --nodaemon -f /home/huantian/.xbindkeysrc";
        KillMode = "process";
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