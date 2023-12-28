{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.helix;
in
{
  options.modules.editors.helix = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.helix ];
    environment.variables.EDITOR = "hx";
  };
}
