{ config, pkgs, lib, inputs, ... }:

{
  config = {
    security.doas.enable = true;
    security.sudo.enable = false;
    security.doas.extraRules = [{
      users = [ "huantian" ];
      keepEnv = true;
      persist = true;
    }];
  };
}
