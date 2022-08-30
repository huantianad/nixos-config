{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.vscode;
in
{
  options.modules.editors.vscode = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.fenix.overlay
    ];

    environment.systemPackages = with pkgs; [
      rnix-lsp
    ];

    home-manager.users.huantian.programs.vscode = {
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
  };
}
