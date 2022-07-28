{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./gaming
    ./xbindkeys
    ./zsh

    ./doas.nix
    ./git.nix
    ./unity.nix
    ./vim.nix
  ];
}