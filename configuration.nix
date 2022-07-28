{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModule
    inputs.declarative-cachix.nixosModules.declarative-cachix
    ./hardware-configuration.nix
    ./programs
    ./system
  ];

  nixpkgs.overlays = [
    inputs.fenix.overlay
  ];

  cachix = [
    { name = "nix-community"; sha256 = "1955r436fs102ny80wfzy99d4253bh2i1vv1x4d4sh0zx2ssmhrk"; }
  ];

  environment.systemPackages = with pkgs; [
    librewolf
    kate
    (discord.override { withOpenASAR = true; })
    wget
    element-desktop
    tldr
    ark
    file
    gcc
    bat

    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
  ];

  services.usbmuxd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
