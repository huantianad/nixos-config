{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.touchpad;
in {
  options.modules.hardware.touchpad = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libinput-gestures
      ydotool
    ];

    home-manager.users.huantian.home.file = let
      ydotool-service = "${pkgs.ydotool}/share/systemd/user/ydotool.service";
      gestures-service = "${pkgs.libinput-gestures}/share/systemd/user/libinput-gestures.service";
    in {
      ".config/systemd/user/ydotool.service".source = ydotool-service;
      ".config/systemd/user/default.target.wants/ydotool.service".source = ydotool-service;
      ".config/systemd/user/libinput-gestures.service".source = gestures-service;
      ".config/systemd/user/graphical-session.target.wants/libinput-gestures.service".source = gestures-service;
    };
  };
}
