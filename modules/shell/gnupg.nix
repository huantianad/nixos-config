{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.gnupg;
in
{
  options.modules.shell.gnupg = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };
  };
}
