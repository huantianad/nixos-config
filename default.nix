{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nix-index-database.nixosModules.nix-index
  ] ++ (mapModulesRec' (toString ./modules) import);

  # https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module
  # "use the global pkgs that is configured via the system level nixpkgs options"
  # "This saves an extra Nixpkgs evaluation, adds consistency, and removes the dependency on NIX_PATH,
  #  which is otherwise used for importing Nixpkgs."
  home-manager.useGlobalPkgs = true;

  # Configure nix and nixpkgs
  nixpkgs.config.allowUnfree = true;
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix = {
    # package = pkgs.nixVersions.unstable;

    extraOptions = "experimental-features = nix-command flakes";

    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

    registry.nixpkgs.flake = inputs.nixpkgs;

    nixPath = [
      "nixpkgs=/etc/nixpkgs/channels/nixpkgs"
    ];
  };

  systemd.tmpfiles.rules = [
    "L+ /etc/nixpkgs/channels/nixpkgs - - - - ${inputs.nixpkgs}"
  ];

  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;

  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    bind
    cached-nix-shell
    git
    vim
    wget
    gnumake
    unzip
  ];
}
