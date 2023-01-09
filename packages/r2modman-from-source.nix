{ lib, stdenv, mkYarnPackage, fetchFromGitHub, makeWrapper, steam-run }:

mkYarnPackage rec {
  name = "r2modman";
  version = "3.1.34";

  src = fetchFromGitHub {
    owner = "ebkr";
    repo = "r2modmanPlus";
    rev = "v${version}";
    sha256 = "sha256-iaD04brW/bXxb2fK2Atam8rXhj++VLTvlGJvGQFDjq8=";
  };

  doDist = false;
  dontStrip = true;

  NODE_OPTIONS = "--openssl-legacy-provider";

  buildPhase = ''
    # yarn --offline quasar build
    yarn --offline quasar build -m electron
  '';

  installPhase = ''
    runHook preInstall

    # # Remove dev deps that aren't necessary for running the app
    # npm prune --omit=dev

    ls
    mkdir $out
    cp -r deps node_modules $out

    # mkdir -p $out
    # cp -r opt/ usr/share/ $out

    # mkdir -p $out/bin
    # ln -s $out/opt/r2modman/r2modman $out/bin/

    # substituteInPlace $out/share/applications/r2modman.desktop \
    #   --replace /opt/ $out/opt/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple and easy to use mod manager for several games using Thunderstore";
    homepage = "https://github.com/ebkr/r2modmanPlus";
    downloadPage = "https://github.com/ebkr/r2modmanPlus/releases";
    changelog = "https://github.com/ebkr/r2modmanPlus/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
  };
}
