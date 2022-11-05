{ pkgs, config, lib, ... }:

with builtins;
with lib;
{
  i18n.defaultLocale = mkDefault "en_US.utf8";

  networking.domain = "huantian.dev";
  networking.firewall.enable = true;

  boot.cleanTmpDir = true;

  modules = {
    editors = {
      vim.enable = true;
    };

    services = {
      ssh.enable = true;
    };

    shell = {
      zsh.enable = true;
      doas.enable = true;
      git.enable = true;
      gnupg.enable = true;
      nix.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    bat
    btop
    curl
    file
    htop
    killall
    ripgrep
    unzip
    wget
  ];
}
