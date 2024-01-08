{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.git;
in
{
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.git ];

    home-manager.users.huantian.programs.git = {
      enable = true;
      userName = "huantian";
      userEmail = "davidtianli@gmail.com";

      signing.key = "731A7A05AD8B3AE5956AC2274A0318E04E555DE5";
      signing.signByDefault = true;

      lfs.enable = true;

      diff-so-fancy.enable = true;

      extraConfig = {
        core.autocrlf = "input";
        core.askpass = mkIf config.modules.desktop.kde.enable "${pkgs.libsForQt5.ksshaskpass}/bin/ksshaskpass";
        init.defaultBranch = "main";
        push.autoSetupRemote = "true";
        pull.rebase = "true";
        rebase.autoStash = "true";
      };
    };
  };
}
