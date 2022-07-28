{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./editors
    ./gaming
    ./xbindkeys
    ./zsh

    ./discord.nix
    ./doas.nix
    ./git.nix
    ./unity.nix
  ];
}