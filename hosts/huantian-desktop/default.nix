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
        dolphin.setUdevRules = true;
        steam.enable = true;
      };

      programs = {
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

    services = {
      usbmuxd.enable = true;
    };

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

  environment.systemPackages = with pkgs; with inputs.jtoinar.packages.${pkgs.system}; [
    # aw-webui
    # aw-qt
    # aw-server-rust
    # aw-watcher-afk
    # aw-watcher-window
  ];

  services.cron = {
    enable = true;
  };
}
