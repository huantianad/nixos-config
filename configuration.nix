{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModule
    ./hardware-configuration.nix
    ./programs
    ./system
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
