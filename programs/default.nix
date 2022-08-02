{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./dev
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