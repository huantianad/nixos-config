{ config, pkgs, lib, inputs, ... }:

{
  config = {
    users.mutableUsers = false;
    users.users.huantian = {
      isNormalUser = true;
      description = "David Li";
      extraGroups = [ "networkmanager" "wheel" "input" ];
      shell = pkgs.zsh;
      hashedPassword = "$6$.r68MxqkJ5EkYsO1$UcxXYU5ZS7mKLw74SqHzoLYbc6sJzrzCmTlY7oyC0aPBveceIFc0RpEMhHyTGmtZ1ROmH0mMyCJw8XyEoyYvr1";
    };

    home-manager.users.huantian.home.stateVersion = config.system.stateVersion;
    home-manager.users.huantian.nixpkgs.config.allowUnfree = true;
  };
}
