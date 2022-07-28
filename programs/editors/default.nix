{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./vscode

    ./jetbrains.nix
    ./vim.nix
  ];

  config = {
    fonts.fonts = with pkgs; [
      fira-code
    ];
  };
}