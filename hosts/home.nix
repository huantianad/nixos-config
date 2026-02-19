{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with builtins;
with lib; {
  # Network Manager + wifi
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;
  services.printing.drivers = with pkgs; [pantum-driver];

  nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];
  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };

  # Fix opening links in firefox from fhs with older nss, #160923, #197118
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # Tell SSH to use ksshaskpass even when in terminal
  programs.ssh.enableAskPassword = true;
  programs.ssh.askPassword = lib.getExe pkgs.kdePackages.ksshaskpass;
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  programs.nix-ld.enable = true;

  # Spell check packages
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
  ];

  programs.nh = {
    enable = true;
    flake = "/home/huantian/nixos-config";
  };

  # xdg-base-dirs stuff
  environment.sessionVariables.GDBHISTFILE = "$XDG_CONFIG_HOME/gdb/.gdb_history";
  environment.sessionVariables.GNUPGHOME = "$XDG_DATA_HOME/gnupg";
  environment.sessionVariables.GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";

  boot.supportedFilesystems = ["ntfs"];
  boot.blacklistedKernelModules = ["ntfs3"];
}
