{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModule
    ./hardware-configuration.nix
    ./programs
    ./system
  ];

  nixpkgs.overlays = [
    inputs.fenix.overlay
  ];

  environment.systemPackages = with pkgs; [
    librewolf
    kate
    element-desktop
    ark
    vlc
    gimp
    qbittorrent
    zoom-us
    partition-manager
    baobab
    libreoffice-qt
  ];

  services.xserver.desktopManager.plasma5.excludePackages = with pkgs; [
    elisa # Default KDE video player, use VLC instead
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
  };

  programs.dconf.enable = true;
  services.usbmuxd.enable = true;

  fonts.fonts = with pkgs; [
    liberation_ttf

    # Some CJK Fonts
    source-han-serif
    source-han-sans
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

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
