{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./vscode

    ./rider.nix
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
