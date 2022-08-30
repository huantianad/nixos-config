{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.nix;
in
{
  options.modules.shell.nix = {
    enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    nix.extraOptions = "experimental-features = nix-command flakes";
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    nix.settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
  };
}
