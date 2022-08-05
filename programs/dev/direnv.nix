{ config, pkgs, lib, inputs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      direnv
      nix-direnv
    ];

    # Nix options for derivations to persist garbage collection
    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    environment.pathsToLink = [
      "/share/nix-direnv"
    ];

    # Flake support
    nixpkgs.overlays = [
      (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; })
    ];

    home-manager.users.huantian.programs.zsh.initExtra = "eval \"\$(direnv hook zsh)\"";
  };
}
