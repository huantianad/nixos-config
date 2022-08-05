{ config, pkgs, lib, inputs, ... }:

{
  config = {
    nixpkgs.config.allowUnfree = true;

    nix.extraOptions = "experimental-features = nix-command flakes";
  };
}
