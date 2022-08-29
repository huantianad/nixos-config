{ config, pkgs, lib, inputs, ... }:

{
  config.home-manager.users.huantian.programs.vscode = {
    enable = true;
    userSettings = import ./settings.nix { inherit pkgs; };
    extensions = with pkgs.vscode-extensions; [
      matklad.rust-analyzer-nightly # Provided by fenix

      njpwerner.autodocstring
      bungcip.better-toml
      ms-dotnettools.csharp
      vadimcn.vscode-lldb
      adpyke.codesnap

      redhat.java
      oderwat.indent-rainbow
      pkief.material-icon-theme

      github.vscode-pull-request-github
      eamodio.gitlens
      redhat.vscode-yaml
    ];
  };
}
