{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = {
    users.users.huantian = {
      isNormalUser = true;
      description = "David Li";
      extraGroups = ["networkmanager" "wheel" "input" "power" "podman"];
      shell = pkgs.zsh;
      hashedPassword = "$6$.r68MxqkJ5EkYsO1$UcxXYU5ZS7mKLw74SqHzoLYbc6sJzrzCmTlY7oyC0aPBveceIFc0RpEMhHyTGmtZ1ROmH0mMyCJw8XyEoyYvr1";
    };

    home-manager.users.huantian.home.stateVersion = config.system.stateVersion;
    home-manager.users.huantian.nixpkgs.config.allowUnfree = true;
    home-manager.users.huantian.nix.gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 3d";
    };
  };
}
