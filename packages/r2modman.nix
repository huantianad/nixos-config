{ lib, stdenv, fetchurl
, dpkg, autoPatchelfHook, wrapGAppsHook

, xorg
, glibc
, dbus
, cairo
, nss_latest
, gtk3
, gnome2
, libxkbcommon
, libdrm
, cups
, mesa
, alsa-lib

, fontconfig
, libpulseaudio
, systemd
}:

stdenv.mkDerivation rec {
  name = "r2modman";
  version = "3.1.32";

  src = fetchurl {
    url = "https://github.com/ebkr/r2modmanPlus/releases/download/v${version}/r2modman_${version}_amd64.deb ";
    sha256 = "sha256-8pLMcszXc1hFqfjzQzCWHIN8vcQzd8a16TQTYi8BySI=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    # ldd xorg
    xorg.libXcomposite
    xorg.libXrandr
    xorg.libXext
    xorg.libXdamage
    xorg.libXfixes
    xorg.libxcb
    xorg.libxshmfence
    xorg.libXScrnSaver
    xorg.libXtst

    # ldd general
    glibc
    dbus
    cairo
    nss_latest
    gtk3
    gnome2.pango
    libxkbcommon
    libdrm
    cups
    mesa
    alsa-lib
  ];

  libPath = lib.makeLibraryPath [
    libpulseaudio
    systemd
    fontconfig
  ];

  unpackCmd = ''
    runHook preUnpack

    dpkg-deb -x $src src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt/ usr/share/ $out

    ln -s $out/opt/r2modman/r2modman $out/bin/

    substituteInPlace $out/share/applications/r2modman.desktop \
      --replace /opt/ $out/opt/

    runHook postInstall
  '';

  dontWrapGApps = true;

  postFixup = ''
    wrapProgram $out/opt/r2modman/r2modman \
      --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/r2modman \
      --add-flags --no-sandbox \
      ''${gappsWrapperArgs[@]}
  '';

  meta = with lib; {
    description = "A simple and easy to use mod manager for several games using Thunderstore";
    license = licenses.mit;
    maintainers = with maintainers; [ huantian ];
    homepage = "https://github.com/ebkr/r2modmanPlus";
  };
}