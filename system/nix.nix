{ config, pkgs, lib, inputs, ... }:

{
  config = {
    nixpkgs.config.allowUnfree = true;

    nix.settings.auto-optimise-store = true;
    nix.extraOptions = "experimental-features = nix-command flakes";
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };
}
