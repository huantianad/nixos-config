{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./dev
    ./editors
    ./gaming
    ./zsh

    ./discord.nix
    ./doas.nix
    ./git.nix
    ./unity.nix
    ./xbindkeys.nix
  ];
}
