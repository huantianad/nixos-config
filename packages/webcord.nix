{ lib, stdenv, buildNpmPackage, fetchFromGitHub, copyDesktopItems, python3, electron_20, makeDesktopItem }:

buildNpmPackage rec {
  name = "webcord";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "SpacingBat3";
    repo = "WebCord";
    rev = "v${version}";
    sha256 = "sha256-e+y/M+/gjezHoNrdXeFhqtvxbPdhRSDOQlwK1nUhNfo=";
  };

  npmDepsHash = "sha256-F6d58VxTpeYdpp2InbXY8gHM9o43dnect+DQAreoRQI=";

  nativeBuildInputs = [
    copyDesktopItems
    python3
  ];

  # npm install will error when electron tries to download its binary
  # we don't need it anyways since we wrap the program with our nixpkgs electron
  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # remove husky commit hooks, errors and aren't needed for packaging
  postPatch = ''
    rm -rf .husky
  '';

  # override installPhase so we can copy the only folders that matter
  installPhase = ''
    runHook preInstall

    # Remove dev deps that aren't necessary for running the app
    npm prune --omit=dev

    mkdir -p $out/lib/node_modules/webcord
    cp -r app node_modules sources package.json $out/lib/node_modules/webcord/

    install -Dm644 sources/assets/icons/app.png $out/share/icons/hicolor/256x256/apps/webcord.png

    makeWrapper '${electron_20}/bin/electron' $out/bin/webcord \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}" \
      --inherit-argv0 \
      --add-flags $out/lib/node_modules/webcord/

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "webcord";
      exec = "webcord";
      icon = "webcord";
      desktopName = "WebCord";
      comment = meta.description;
      categories = [ "Network" "InstantMessaging" ];
    })
  ];

  meta = with lib; {
    description = "A Discord and Fosscord electron-based client implemented without Discord API";
    homepage = "https://github.com/SpacingBat3/WebCord";
    downloadPage = "https://github.com/SpacingBat3/WebCord/releases";
    changelog = "https://github.com/SpacingBat3/WebCord/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
  };
}
