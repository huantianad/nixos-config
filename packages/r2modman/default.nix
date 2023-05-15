{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, nodejs
, yarn
, fixup_yarn_lock
, makeWrapper
, copyDesktopItems
, electron
, makeDesktopItem
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "r2modman";
  version = "3.1.41";

  src = fetchFromGitHub {
    owner = "ebkr";
    repo = "r2modmanPlus";
    rev = "v${version}";
    hash = "sha256-nnmzIpV+Rn2zBJDBUehcUpvh3U4jqGLLGoIoxlZy6SA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-CXitb/b2tvTfrkFrFv4KP4WdmMg+1sDtC/s2u5ezDfI=";
  };

  nativeBuildInputs = [
    nodejs
    yarn
    fixup_yarn_lock
    makeWrapper
    copyDesktopItems
  ];

  configurePhase = ''
    runHook preConfigure

    # Workaround for webpack bug
    # https://github.com/webpack/webpack/issues/14532
    export NODE_OPTIONS="--openssl-legacy-provider"
    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline quasar build --mode electron --skip-pkg

    # Remove dev dependencies.
    yarn install --production --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${pname}
    cp -r dist/electron/UnPackaged/. \
      node_modules \
      $out/share/${pname}

    (cd public/icons
      for img in *png; do
        dimensions=''${img#favicon-}
        dimensions=''${dimensions%.png}
        mkdir -p $out/share/icons/hicolor/$dimensions/apps
        cp $img $out/share/icons/hicolor/$dimensions/apps/${pname}.png
      done)

    makeWrapper '${electron}/bin/electron' "$out/bin/r2modman" \
      --inherit-argv0 \
      --add-flags "$out/share/r2modman" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = pname;
      comment = meta.description;
      categories = [ "Game" ];
      keywords = [ "launcher" "mod manager" "thunderstore" ];
    })
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Unofficial Thunderstore mod manager";
    homepage = "https://github.com/ebkr/r2modmanPlus";
    changelog = "https://github.com/ebkr/r2modmanPlus/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ aidalgol ];
    inherit (electron.meta) platforms;
    mainProgram = pname;
  };
}
