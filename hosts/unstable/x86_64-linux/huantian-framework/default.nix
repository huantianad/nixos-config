{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
    inputs.lanzaboote.nixosModules.lanzaboote
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
        armcord.enable = true;
        fcitx.enable = true;
        qmk.enable = false;
        tauon.enable = true;
        waydroid.enable = false;
        xbindkeys.enable = false;
      };
    };

    dev = {
      cc.enable = true;
      tex.enable = false;
      unity.enable = false;
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

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # Some battery life tuning
  services.tlp.enable = true;
  services.tlp.settings = {
    PCIE_ASPM_ON_BAT = "powersupersave";

    INTEL_GPU_MIN_FREQ_ON_BAT = 100;
    INTEL_GPU_MAX_FREQ_ON_BAT = 800;
    INTEL_GPU_BOOST_FREQ_ON_BAT = 1000;
    INTEL_GPU_MIN_FREQ_ON_AC = 100;
    INTEL_GPU_MAX_FREQ_ON_AC = 1300;
    INTEL_GPU_BOOST_FREQ_ON_AC = 1300;

    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 30;

    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  };
  # Disable power-profiles-daemon as it conflicts with tlp
  services.power-profiles-daemon.enable = false;
  # Thermal config
  services.thermald.enable = true;

  # Disable fingerprint auth on first login
  # SDDM fingerprint is buggy and I need to type password for KWallet anyway
  security.pam.services.sddm.fprintAuth = false;
  security.pam.services.login.fprintAuth = false;

  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
