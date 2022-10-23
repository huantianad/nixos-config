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
        default = "librewolf";
        librewolf.enable = true;
        chromium.enable = true;
      };

      gaming = {
        enable = true;
        dolphin.enable = false;
        dolphin.setUdevRules = false;
        steam.enable = false;
      };

      programs = {
        powercord.enable = false;
        fcitx.enable = true;
        tauon.enable = true;
        jetbrains-toolbox.enable = false;
        unity.enable = false;
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
      rider.enable = false;
    };

    hardware = {
      bluetooth.enable = true;
      intel.enable = true;
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

  # Some battery life tuning
  services.tlp.enable = true;
  # Disable power-profiles-daemon as it conflicts with tlp
  services.power-profiles-daemon.enable = false;

  # Fingerprint support
  services.fprintd.enable = true;
  security.pam.services."sddm".fprintAuth = true;

  # Touchpad gestures
  environment.systemPackages = with pkgs; [
    libinput-gestures
    ydotool
    checkra1n
    my.xmage
  ];

  home-manager.users.huantian.home.file =
    let
      ydotool-service = "${pkgs.ydotool}/share/systemd/user/ydotool.service";
      gestures-service = "${pkgs.libinput-gestures}/share/systemd/user/libinput-gestures.service";
    in
    {
      ".config/systemd/user/ydotool.service".source = ydotool-service;
      ".config/systemd/user/default.target.wants/ydotool.service".source = ydotool-service;
      ".config/systemd/user/libinput-gestures.service".source = gestures-service;
      ".config/systemd/user/graphical-session.target.wants/libinput-gestures.service".source = gestures-service;
    };

  services.xserver.libinput.touchpad = {
    naturalScrolling = true;
  };

  # This is used for ambient light sensor, but disable it for now
  # Since it breaks the function keys alternate layer
  boot.blacklistedKernelModules = [
    "hid_sensor_hub"
  ];
}
