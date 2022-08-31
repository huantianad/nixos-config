{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.framework
    ../home.nix
    ./hardware-configuration.nix
  ];

  modules = {
    desktop = {
      kde = {
        enable = true;
        latte-dock.enable = false;
        autoLogin = false;
      };
      random-apps.enable = true;
      fonts.enable = true;
      wayland.enable = true;

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
        discord.enable = false;
        fcitx.enable = true;
        tauon.enable = true;
        jetbrains-toolbox.enable = false;
        unity.enable = true;
        webcord.enable = true;
        xbindkeys.enable = false;
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
      intel.enable = true;
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

  # Fingerprint support
  services.fprintd.enable = true;
  security.pam.services."sddm".fprintAuth = true;
}
