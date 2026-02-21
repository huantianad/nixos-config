{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../../../home.nix
    ./disk-configuration.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.11";

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
        aw.enable = false;
        fcitx.enable = true;
        gamemode.enable = true;
        kitty.enable = true;
        qmk.enable = false;
        tauon = {
          enable = false;
          openFirewall = true;
        };
        xbindkeys.enable = true;
      };
    };

    dev = {
      cc.enable = true;
      tex.enable = false;
      unity.enable = true;
    };

    editors = {
      helix.enable = true;
      vscode.enable = false;
      vim.enable = false;
      rider.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = false;
      pipewire.enable = true;
    };

    services = {
      usbmuxd.enable = false;
    };

    shell = {
      zsh.enable = true;
      direnv.enable = true;
      doas.enable = true;
      git.enable = true;
      gnupg.enable = false;
    };
  };

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
