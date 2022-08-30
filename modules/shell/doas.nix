{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.doas;
in
{
  options.modules.shell.doas = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    security.sudo.enable = false;
    security.doas.enable = true;
    security.doas.extraRules = [{
      users = [ "huantian" ];
      keepEnv = true;
      persist = true;
    }];
  };
}
