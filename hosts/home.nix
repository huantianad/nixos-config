{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib; {
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = mkDefault "en_US.utf8";

  # Network Manager + wifi
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [pantum-driver];

  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_6_10;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };

  # Fix opening links in firefox from fhs with older nss, #160923, #197118
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # Tell SSH to use ksshaskpass even when in terminal
  programs.ssh.enableAskPassword = true;
  programs.ssh.askPassword = lib.getExe pkgs.kdePackages.ksshaskpass;
  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  programs.nix-ld.enable = true;

  # Spell check packages
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
  ];

  programs.nh = {
    enable = true;
    flake = "/home/huantian/nixos-config";
  };
}
