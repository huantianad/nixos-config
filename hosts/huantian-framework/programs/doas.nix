{ config, pkgs, lib, inputs, ... }:

{
  config = {
    security.sudo.enable = false;
    security.doas.enable = true;
    security.doas.extraRules = [{
      users = [ "huantian" ];
      keepEnv = true;
      persist = true;
    }];
  };
}
