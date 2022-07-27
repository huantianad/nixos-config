{ pkgs, config, lib, ... }:

{
  config = {
    environment.systemPackages = [ pkgs.git ];

    home-manager.users.huantian.programs = {
      git = {
        enable = true;
        userName  = "huantian";
        userEmail = "davidtianli@gmail.com";

        signing.key = "731A7A05AD8B3AE5956AC2274A0318E04E555DE5";
        signing.signByDefault = true;

        lfs.enable = true;

        diff-so-fancy.enable = true;

        extraConfig = {
          commit.gpgsign = true;
          credential.helper = "store";
          core.autocrlf = "input";
          init.defaultBranch = "main";
        };
      };
    };
  };
}
