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

        # webcord.enable = true;

        fcitx.enable = true;
        qmk.enable = true;
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
      tex.enable = false;
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

  environment.systemPackages = with pkgs; [
    (discord.override { withOpenASAR = true; })
    (libsForQt5.callPackage ../../musescore.nix { })
    my.xmage
    butler
  ];

  # Causes error on rebuild sometime, slows startup => disable
  systemd.services.NetworkManager-wait-online.enable = false;

  # Increase size of /run/user/1000
  services.logind.extraConfig = "RuntimeDirectorySize=4G";

  services.fstrim.enable = true;

  # Fix high refresh rate on KDE https://bugs.kde.org/show_bug.cgi?id=433094#c15
  # Also turn off flipping in nvidia-settings
  # and run nvidia-settings --load-config-only on startup
  environment.sessionVariables = {
    KWIN_X11_REFRESH_RATE = "155000";
    KWIN_X11_NO_SYNC_TO_VBLANK = "1";
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };

      # Warning: GPU optimisations have the potential to damage hardware
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
}
