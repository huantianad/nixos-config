{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
    ../../../home.nix
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
        dolphin.enable = false;
        dolphin.setUdevRules = true;
        steam.enable = true;
      };

      programs = {
        armcord.enable = false;
        fcitx.enable = true;
        gamemode.enable = true;
        qmk.enable = false;
        tauon.enable = true;
        tauon.openFirewall = true;
        waydroid.enable = false;
        xbindkeys.enable = false;
      };
    };

    dev = {
      cc.enable = true;
      matlab.enable = true;
      tex.enable = false;
      unity.enable = true;
    };

    editors = {
      vscode.enable = true;
      vim.enable = true;
      rider.enable = true;
    };

    hardware = {
      battery.enable = true;
      bluetooth.enable = true;
      intel.enable = true;
      lanzaboote.enable = true;
      pipewire.enable = true;
      touchpad.enable = false;
    };

    services = {
      usbmuxd.enable = false;
    };

    shell = {
      zsh.enable = true;
      direnv.enable = true;
      doas.enable = true;
      git.enable = true;
      gnupg.enable = true;
    };
  };

  time.timeZone = "America/Los_Angeles";

  # Disable fingerprint auth on first login
  # SDDM fingerprint is buggy and I need to type password for KWallet anyway
  security.pam.services.sddm.fprintAuth = false;
  security.pam.services.login.fprintAuth = false;

  environment.systemPackages = with pkgs; [
    my.vesktop
    my.musescore3
    helix
    nil
  ];
}
