{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
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
        dolphin.enable = true;
        dolphin.setUdevRules = true;
        qrookie.enable = true;
        steam.enable = true;
      };

      programs = {
        aw.enable = false;
        fcitx.enable = true;
        gamemode.enable = true;
        kitty.enable = true;
        qmk.enable = false;
        tauon = {
          enable = true;
          openFirewall = true;
        };
        xbindkeys.enable = true;
      };
    };

    dev = {
      cc.enable = true;
      nim.enable = true;
      tex.enable = false;
      unity.enable = true;
    };

    editors = {
      helix.enable = true;
      vscode.enable = false;
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
      ssh.enable = true;
    };

    shell = {
      zsh.enable = true;
      direnv.enable = true;
      doas.enable = true;
      git.enable = true;
      gnupg.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  # Increase size of /run/user/1000
  services.logind.extraConfig = "RuntimeDirectorySize=4G";

  # Earlyoom because unity + rider often locks up system with too much memory usage
  services.earlyoom.enable = true;
}
