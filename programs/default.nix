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
    ./toolbox.nix
    ./unity.nix
    ./xbindkeys.nix
  ];
}
