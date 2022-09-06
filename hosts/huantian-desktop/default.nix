{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  modules = {
    desktop = {
      kde = {
        enable = true;
        latte-dock.enable = true;
        autoLogin = true;
      };
      random-apps.enable = true;
      fonts.enable = true;

      browsers = {
        librewolf.enable = true;
      };

      gaming = {
        enable = true;
        dolphin.enable = true;
        dolphin.setUdevRules = false;
        steam.enable = true;
      };

      programs = {
        powercord.enable = true;
        fcitx.enable = true;
        tauon = {
          enable = true;
          openFirewall = true;
        };
        jetbrains-toolbox.enable = false;
        unity.enable = true;
        webcord.enable = false;
        xbindkeys.enable = true;
      };
    };

    dev = {
      cc.enable = true;
    };

    editors = {
      vscode.enable = true;
      vim.enable = true;
      rider.enable = true;
    };

    hardware = {
      nvidia.enable = true;
      pipewire.enable = true;
    };

    services = { };

    shell = {
      zsh.enable = true;
      direnv.enable = true;
      doas.enable = true;
      git.enable = true;
      gnupg.enable = true;
      nix.enable = true;
    };
  };

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  programs.dconf.enable = true;
  services.usbmuxd.enable = true;

  services.cron = {
    enable = true;
  };
}
