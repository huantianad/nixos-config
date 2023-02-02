{ lib, appimageTools, libsecret, runCommand }:

appimageTools.wrapAppImage rec {
  name = "jetbrains-toolbox";
  version = "1.26.2.13244";

  src =
    let
      tarball = fetchTarball {
        url = "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${version}.tar.gz";
        sha256 = "sha256:172cp5lmpkr5jqqpqy3qnpm0vlw8ni5kkh3a211nma89903x6c5h";
      };
    in
    runCommand "jetbrains-toolbox-extracted"
      { buildInputs = [ appimageTools.appimage-exec ]; } ''
      appimage-exec.sh -x $out ${tarball}/jetbrains-toolbox
    '';

  extraPkgs = pkgs: [
    libsecret
  ];

  meta = with lib; {
    description = "Download and manage JetBrains IDEs and projects.";
    homepage = "https://www.jetbrains.com/toolbox-app/";
    license = licenses.unfree;
    maintainers = with maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
  };
}
