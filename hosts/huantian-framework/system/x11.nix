{ config, pkgs, lib, inputs, ... }:

{
  config = {
    # Enable nvidia drivers
    services.xserver.videoDrivers = [ "intel" ];

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    # latte-dock for kde
    # environment.systemPackages = [ pkgs.latte-dock ];

    # Enable automatic login for the user.
    # services.xserver.displayManager.autoLogin.enable = true;
    # services.xserver.displayManager.autoLogin.user = "huantian";

    nixpkgs.config.librewolf.enablePlasmaBrowserIntegration = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Configure keymap in X11
    # services.xserver = {
    #   layout = "us";
    #   xkbVariant = "";
    # };
  };
}
