{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [ inputs.home-manager.nixosModules.home-manager ]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  # https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module
  # "use the global pkgs that is configured via the system level nixpkgs options"
  # "This saves an extra Nixpkgs evaluation, adds consistency, and removes the dependency on NIX_PATH,
  #  which is otherwise used for importing Nixpkgs."
  home-manager.useGlobalPkgs = true;

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  # environment.variables.DOTFILES = config.dotfiles.dir;
  # environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix =
    # let
    #   filteredInputs = filterAttrs (n: _: n != "self") inputs;
    #   nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    #   registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    # in
    {
      # package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
      # nixPath = nixPathInputs ++ [
      #   "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
      #   "dotfiles=${config.dotfiles.dir}"
      # ];
      # registry = registryInputs // { dotfiles.flake = inputs.self; };
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        auto-optimise-store = true;
      };
    };

  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;

  ## Some reasonable, global defaults
  # Use the latest kernel
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };

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
