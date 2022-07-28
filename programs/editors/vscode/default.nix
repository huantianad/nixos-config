{ config, pkgs, lib, inputs, ... }:

{
  config.home-manager.users.huantian.programs.vscode = {
    enable = true;
    userSettings = import ./settings.nix { inherit pkgs; };
    extensions = with pkgs.vscode-extensions; [
      matklad.rust-analyzer-nightly  # Provided by fenix
    ];
  };
}