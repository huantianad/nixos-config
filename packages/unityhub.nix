{ lib, stdenv, fetchurl, dpkg, makeWrapper, buildFHSUserEnv }:

stdenv.mkDerivation rec {
  name = "unityhub";
  version = "3.3.0";

  src = fetchurl {
    url = "https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${version}.deb";
    sha256 = "sha256-W5NPOvIUFDyNuauUDXD/jaMD5USPO/7Wty6FuxtFbRk=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  fhsEnv = buildFHSUserEnv {
    name = "${name}-fhs-env";
    runScript = "";
    targetPkgs = pkgs: with pkgs; [
      # Unity Hub dependencies
      cups
      gtk3
      expat
      libxkbcommon
      lttng-ust_2_12
      krb5
      alsa-lib
      nss_latest
      libdrm
      mesa
      nspr
      atk
      dbus
      at-spi2-core
      # at-spi2-atk - at-spi2-core used to be split up into 2 packages
      pango
      xorg.libXcomposite
      xorg.libXrandr
      xorg.libXext
      xorg.libXdamage
      xorg.libXfixes
      xorg.libxcb
      xorg.libxshmfence
      xorg.libXScrnSaver
      xorg.libXtst

      libva
      openssl_1_1
      cairo
      xdg-utils
      libnotify
      libuuid
      libsecret
      udev
      libappindicator
      wayland
      cpio
      icu
      libpulseaudio # Not a ldd thing, but needed for sound to work

      # Editor dependencies
      libglvnd # provides ligbl
      xorg.libX11
      xorg.libXcursor
      glib
      gdk-pixbuf
      libxml2
      zlib
      clang

      # Bug Reporter dependencies
      fontconfig
      freetype
      lsb-release

      # these are probably not needed
      xorg.libXinerama
      # hicolor-icon-theme

      # My Unity projects depend on these
      harfbuzz
      libogg
    ];
  };

  unpackCmd = ''
    runHook preUnpack

    dpkg-deb -x $src src

    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv opt/ usr/share/ $out

    # `unityhub` is a shell wrapper that runs `unityhub-bin`
    # Which we don't need and replace with our own custom wrapper
    makeWrapper ${fhsEnv}/bin/${name}-fhs-env $out/opt/unityhub/unityhub \
      --inherit-argv0 \
      --add-flags $out/opt/unityhub/unityhub-bin

    # Link binary
    mkdir -p $out/bin
    ln -s $out/opt/unityhub/unityhub $out/bin/unityhub

    # Replace absolute path in desktop file to correctly point to nix store
    substituteInPlace $out/share/applications/unityhub.desktop \
      --replace /opt/unityhub/unityhub $out/opt/unityhub/unityhub

    runHook postInstall
  '';

  meta = with lib; {
    description = "Download and manage Unity Projects and installations.";
    homepage = "https://unity3d.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
  };
}
