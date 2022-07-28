{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./gaming
    ./zsh

    ./doas.nix
    ./git.nix
    ./unity.nix
    ./vim.nix
  ];
}