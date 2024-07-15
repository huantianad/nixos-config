{ config, pkgs, lib, inputs, ... }:

{
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

  # Disable virtualbox for now, takes a while to compile and I'm not using it
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
  ];

  # Causes error on rebuild sometime, slows startup => disable
  systemd.services.NetworkManager-wait-online.enable = false;

  # Increase size of /run/user/1000
  services.logind.extraConfig = "RuntimeDirectorySize=4G";

  # Hardcode Nvidia X Server Settings changes to xorg config
  # Fixes issues with second monitor being disabled on startup.
  # services.xserver.screenSection = "Option \"metamodes\" \"DP-4: 2560x1440_155 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNCCompatible=On}, HDMI-0: nvidia-auto-select +2560+360 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}\"";

  # Fix high refresh rate on KDE https://bugs.kde.org/show_bug.cgi?id=433094#c15
  # Also turn off flipping in nvidia-settings
  # and run nvidia-settings --load-config-only on startup
  hardware.nvidia.forceFullCompositionPipeline = true;
  # environment.sessionVariables = {
  #   KWIN_X11_REFRESH_RATE = "155000";
  #   KWIN_X11_NO_SYNC_TO_VBLANK = "1";
  # };

  # Earlyoom because unity + rider often locks up system with too much memory usage
  services.earlyoom.enable = true;

  # VLC
  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Factorio
  networking.firewall.allowedUDPPorts = [ 34197 ];
}
