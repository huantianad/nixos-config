{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming;
in
{
  options.modules.desktop.gaming = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lutris
      prismlauncher
      scarab
      cockatrice
      airshipper
      (tetrio-desktop.overrideAttrs (oldAttrs:
        let
          tetrio-plus = fetchzip {
            url = "https://gitlab.com/UniQMG/tetrio-plus/uploads/a9647feffc484304ee49c4d3fd4ce718/tetrio-plus_0.23.13_app.asar.zip";
            sha256 = "sha256-NSOVZjm4hDXH3f0gFG8ijLmdUTyMRFYGhxpwysoYIVg=";
          };
        in
        {
          installPhase = oldAttrs.installPhase + "
            cp ${tetrio-plus}/app.asar $out/opt/TETR.IO/resources/
          ";
        }
      ))
    ];
  };
}
