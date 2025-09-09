{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
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
        fcitx.enable = true;
        gamemode.enable = true;
        kitty.enable = true;
        qmk.enable = true;
        tauon = {
          enable = false;
          openFirewall = true;
        };
        xbindkeys.enable = false;
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
      battery.enable = true;
      bluetooth.enable = true;
      intel.enable = true;
      lanzaboote.enable = true;
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
      gnupg.enable = true;
    };
  };

  # Updating firmware and bios
  services.fwupd.enable = true;

  # Disable fingerprint auth on first login
  # SDDM fingerprint is buggy and I need to type password for KWallet anyway
  security.pam.services.sddm.fprintAuth = false;
  security.pam.services.login.fprintAuth = false;

  # Seems to fix a crash/freeze with RD
  # see https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/10548
  environment.variables.INTEL_DEBUG = "reemit";

  networking.firewall.allowedTCPPorts = [40432];

  boot.supportedFilesystems = ["ntfs"];
  boot.blacklistedKernelModules = ["ntfs3"];
}
