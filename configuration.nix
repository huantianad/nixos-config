# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./zsh
      ./doas.nix
      ./git.nix
      ./vim.nix
      inputs.home-manager.nixosModule
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "huantian-desktop";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Phoenix";

  i18n.defaultLocale = "en_US.utf8";

  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.huantian = {
    isNormalUser = true;
    description = "David Li";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager.users.huantian.home.stateVersion = "22.05";

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "huantian";

  nixpkgs.config.allowUnfree = true;

  nix.extraOptions = "experimental-features = nix-command flakes";

  environment.systemPackages = with pkgs; [
    vscode
    librewolf
    kate
    latte-dock
    discord
    wget
    element
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  fonts.fonts = with pkgs; [
    meslo-lgs-nf
    fira-code
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
