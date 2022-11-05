{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "22.05";

  modules = {
    desktop = {
      kde = {
        enable = true;
        latte-dock.enable = false;
        autoLogin = true;
      };
      random-apps.enable = true;
      fonts.enable = true;

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
        aw.enable = true;

        powercord.enable = true;
        webcord.enable = false;

        butler.enable = true;
        fcitx.enable = true;
        tauon = {
          enable = true;
          openFirewall = true;
        };
        jetbrains-toolbox.enable = false;
        unity.enable = true;
        xbindkeys.enable = true;
      };
    };

    dev = {
      cc.enable = true;
      tex.enable = true;
    };

    editors = {
      vscode.enable = true;
      vim.enable = true;
      rider.enable = true;
    };

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
      pipewire.enable = true;
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

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  programs.dconf.enable = true;

  services.cron = {
    enable = true;
  };

  # Increase size of /run/user/1000
  services.logind.extraConfig = "RuntimeDirectorySize=4G";
}
