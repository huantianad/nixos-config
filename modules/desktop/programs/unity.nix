{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.unity;
in
{
  options.modules.desktop.programs.unity = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.my.unityhub.override {
        extraPkgs = pkgs: with pkgs; [
          harfbuzz
          libogg
        ];
      })
    ];
  };
}
