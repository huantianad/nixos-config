{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./editors
    ./gaming
    ./xbindkeys
    ./zsh

    ./doas.nix
    ./git.nix
    ./unity.nix
  ];
}