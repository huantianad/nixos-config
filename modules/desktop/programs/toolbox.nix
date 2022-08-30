{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.programs.jetbrains-toolbox;

  jetbrains-toolbox = pkgs.appimageTools.wrapAppImage rec {
    name = "jetbrains-toolbox";
    version = "1.25.12627";

    src =
      let
        tarball = fetchTarball {
          url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
          sha256 = "1k9lnk49ns9494pj4xm7jzhkw93khydx1a5azwr7pp2zbkxifi80";
        };
      in
      pkgs.runCommand "thing"
        { buildInputs = [ pkgs.appimageTools.appimage-exec ]; } ''
        appimage-exec.sh -x $out ${tarball}/jetbrains-toolbox
      '';

    extraPkgs = pkgs: with pkgs; [
      libsecret
    ];

    meta = with lib; {
      description = "Download and manage JetBrains IDEs and projects.";
      homepage = "https://www.jetbrains.com/toolbox-app/";
      license = licenses.unfree;
      maintainers = with maintainers; [ ];
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  options.modules.desktop.programs.jetbrains-toolbox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ jetbrains-toolbox ];
  };
}
