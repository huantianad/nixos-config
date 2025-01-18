{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.git];

    home-manager.users.huantian.programs.git = {
      enable = true;
      userName = "huantian";
      userEmail = "davidtianli@gmail.com";

      signing.key = "~/.ssh/id_ed25519.pub";
      signing.signByDefault = true;

      lfs.enable = true;

      diff-so-fancy.enable = true;

      extraConfig = {
        core.autocrlf = "input";
        core.askpass = mkIf config.modules.desktop.kde.enable (lib.getExe pkgs.kdePackages.ksshaskpass);
        gpg.format = "ssh";
        init.defaultBranch = "main";
        push.autoSetupRemote = "true";
        pull.rebase = "true";
        rebase.autoStash = "true";
        rebase.autoSquash = "true";
        rebase.updateRefs = "true";
      };
    };
  };
}
