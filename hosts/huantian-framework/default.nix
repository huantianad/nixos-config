{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
    ../home.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.05";

  modules = {
    desktop = {
      kde.enable = true;
      random-apps.enable = true;
      fonts.enable = true;
      wayland.enable = true;

      browsers = {
        default = "librewolf";
        librewolf.enable = true;
        chromium.enable = true;
      };

      gaming = {
        enable = true;
        dolphin.enable = true;
        dolphin.setUdevRules = true;
        steam.enable = true;
      };

      programs = {
        fcitx.enable = true;
        qmk.enable = true;
        tauon.enable = true;
        jetbrains-toolbox.enable = false;
        unity.enable = false;
        webcord.enable = true;
        xbindkeys.enable = false;
      };
    };

    dev = {
      cc.enable = true;
      tex.enable = false;
    };

    editors = {
      vscode.enable = true;
      vim.enable = true;
      rider.enable = false;
    };

    hardware = {
      bluetooth.enable = true;
      intel.enable = true;
      pipewire.enable = true;
      touchpad.enable = false;
    };

    services = {
      usbmuxd.enable = true;
    };

    shell = {
      zsh.enable = true;
      direnv.enable = true;
      doas.enable = true;
      git.enable = true;
      gnupg.enable = true;
    };
  };

  # Some battery life tuning
  services.tlp.enable = true;
  # Disable power-profiles-daemon as it conflicts with tlp
  services.power-profiles-daemon.enable = false;
  # Thermal config
  services.thermald.enable = true;

  # Disable fingerprint auth on first login
  # SDDM fingerprint is buggy and I need to type password for KWallet anyway
  security.pam.services.sddm.fprintAuth = false;

  environment.systemPackages = with pkgs; [
    checkra1n
  ];
}
