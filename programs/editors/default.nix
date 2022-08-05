{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./vscode

    ./jetbrains.nix
    ./vim.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      rnix-lsp
    ];

    fonts.fonts = with pkgs; [
      fira-code
    ];
  };
}
