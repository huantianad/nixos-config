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

  # Some battery life tuning
  services.tlp.enable = true;
  # Disable power-profiles-daemon as it conflicts with tlp
  services.power-profiles-daemon.enable = false;

  # Fingerprint support
  services.fprintd.enable = true;
  security.pam.services."sddm".fprintAuth = true;

  # Touchpad gestures
  environment.systemPackages = with pkgs; [
    (libinput-gestures.overrideAttrs (attrs: {
      postFixup = attrs.postFixup + ''
        substituteInPlace "$out/share/systemd/user/libinput-gestures.service" --replace "/usr/bin/libinput-gestures" "$out/bin/libinput-gestures"
      '';
    }))
    # wmctrl
    ydotool
  ];

  services.xserver.libinput.touchpad = {
    naturalScrolling = true;
  };
}
