{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.matlab;
in
{
  options.modules.dev.matlab = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.nix-matlab.overlay
    ];

    environment.systemPackages = with pkgs; [
      matlab
    ];
  };
}
