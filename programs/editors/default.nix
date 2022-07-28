{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./jetbrains.nix
    ./vim.nix
    ./vscode.nix
  ];

  config = {
    fonts.fonts = with pkgs; [
      fira-code
    ];
  };
}