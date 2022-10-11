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
        commit.gpgsign = true;
        core.autocrlf = "input";
        init.defaultBranch = "main";

        # temp workaround for git add -P while this is still an issue
        # https://github.com/so-fancy/diff-so-fancy/issues/437
        add.interactive.useBuiltin = false;
      };
    };
  };
}
