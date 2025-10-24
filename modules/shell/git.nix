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

      signing.key = "~/.ssh/id_ed25519.pub";
      signing.signByDefault = true;

      lfs.enable = true;

      settings = {
        user.name = "huantian";
        user.email = "davidtianli@gmail.com";
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

    home-manager.users.huantian.programs.diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
