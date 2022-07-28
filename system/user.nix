{ config, pkgs, lib, inputs, ... }:

{
  config = {

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.huantian = {
      isNormalUser = true;
      description = "David Li";
      extraGroups = [ "networkmanager" "wheel" ];
      shell = pkgs.zsh;
    };

    home-manager.users.huantian.home.stateVersion = "22.05";
    home-manager.users.huantian.nixpkgs.config.allowUnfree = true;
  };
}