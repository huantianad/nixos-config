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
          installPhase = ''
            cp -R $TMP/tetrio-desktop/{usr/share,opt} $out/
            cp ${tetrio-plus}/app.asar $out/opt/TETR.IO/resources/

            wrapProgram $out/opt/TETR.IO/tetrio-desktop \
              --prefix LD_LIBRARY_PATH : ${oldAttrs.libPath}:$out/opt/TETR.IO \
              --prefix GSETTINGS_SCHEMA_DIR : ${pkgs.glib.getSchemaPath pkgs.gtk3}

            ln -s $out/opt/TETR.IO/tetrio-desktop $out/bin/

            substituteInPlace $out/share/applications/tetrio-desktop.desktop \
              --replace "/opt/" "$out/opt/"
          '';
        }
      ))
    ];
  };
}
