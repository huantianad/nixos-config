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
    ./tauon.nix
    ./toolbox.nix
    ./unity.nix
  ];
}
