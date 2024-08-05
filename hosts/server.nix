{
  pkgs,
  config,
  lib,
  ...
}:
with builtins;
with lib; {
  time.timeZone = mkDefault "Etc/UTC";
  i18n.defaultLocale = mkDefault "en_US.utf8";

  networking.domain = "huantian.dev";
  networking.firewall.enable = true;

  boot.tmp.cleanOnBoot = true;

  modules = {
    editors = {
      helix.enable = true;
    };

    services = {
      ssh.enable = true;
    };

    shell = {
      zsh.enable = true;
      git.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
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

  # Disable building documentation, seems to be broken on stable
  documentation.nixos.enable = false;

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
}
