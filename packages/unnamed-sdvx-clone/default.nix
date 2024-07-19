{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  freetype,
  SDL2,
  libjpeg,
  libvorbis,
  libarchive,
  openssl,
  rapidjson,
  curl,
}:
stdenv.mkDerivation rec {
  pname = "unnamed-sdvx-clone";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Drewol";
    repo = "unnamed-sdvx-clone";
    rev = "v${version}";
    hash = "sha256-PiX6R9v6Ris5B89TFCf6Mebe95SGGAdYcryxUTxAZ1E=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    freetype
    SDL2
    libjpeg
    libvorbis
    libarchive
    openssl

    # Dependency for discord-rpc
    rapidjson
  ];

  buildInputs = [
    # System curl for cpr
    curl
  ];

  NIX_CFLAGS_COMPILE = [
    # Old version of nuklear causes stringop-overflow error
    "-Wno-error=stringop-overflow"
  ];

  cmakeFlags = [
    "-DCPR_USE_SYSTEM_CURL=ON"
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out

    cp -r $src/bin/ $out/
    install -DT $src/appimage/usc-game.desktop $out/share/applications/usc-game.desktop
    install -DT $src/appimage/usc-game.png $out/share/icons/hicolor/128x128/apps/usc-game.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "A game based on K-Shoot MANIA and Sound Voltex";
    homepage = "https://github.com/Drewol/unnamed-sdvx-clone";
    downloadPage = "https://github.com/Drewol/unnamed-sdvx-clone/releases";
    changelog = "https://github.com/Drewol/unnamed-sdvx-clone/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [huantian];
    mainProgram = "usc-game";
    platforms = ["x86_64-linux"];
  };
}
