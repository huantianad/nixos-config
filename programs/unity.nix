{ config, pkgs, lib, inputs, ... }:

let
  unityhub = pkgs.stdenv.mkDerivation rec {
    name = "unityhub";
    version = "3.2.0";

    src = pkgs.fetchurl {
      url = "https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${version}.deb";
      sha256 = "0276s4b2h6z8djv2vm7jx5brgg3z1gifj0pajvwmxs7ac5nf4gb6";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook  # Auto wrap binary's dynamic library deps
      wrapGAppsHook
      dpkg
      makeShellWrapper
    ];

    buildInputs = with pkgs; [
      glibc
      gcc-unwrapped
      cups
      gtk3
      xorg.libXcomposite
      xorg.libXrandr
      xorg.libXext
      xorg.libXdamage
      xorg.libXfixes
      xorg.libxcb
      xorg.libxshmfence
      xorg.libXScrnSaver
      xorg.libXtst
      expat
      libxkbcommon
      lttng-ust_2_12
      krb5
      at-spi2-core
      alsa-lib
      nss_latest
      libdrm
      mesa
      fontconfig  # Is this necessary?
      udev
      libudev0-shim  # Is this necessary?
      xdg-utils
      libnotify
      libuuid
      libsecret
      cairo
      openssl_3
      libva
      libappindicator
      wayland
    ];

    libPath = with pkgs; lib.makeLibraryPath [
      libva
      openssl_3
      cairo
      xdg-utils
      libnotify
      libuuid
      libsecret
      udev
      xorg.libXScrnSaver
      xorg.libXtst
      libappindicator
      wayland
    ];

    sourceRoot = ".";
    unpackPhase = "dpkg -x $src .";

    dontConfigure = true;
    dontBuild = true;

    installPhase= ''
      runHook preInstall

      mkdir -p $out/bin

      mv usr/share/ $out/share
      mv opt/ $out/opt
      ln -s $out/opt/unityhub/unityhub-bin $out/bin/unityhub

      substituteInPlace $out/share/applications/unityhub.desktop \
        --replace /opt/ $out/opt/

      wrapProgramShell $out/opt/unityhub/unityhub-bin \
        --prefix LD_LIBRARY_PATH : ${libPath} \
        --append-flags no-sandbox

      chmod 4755 '$out/opt/unityhub/chrome-sandbox' || true

      runHook postInstall
    '';

    meta = with lib; {
      description = "Download and manage Unity Projects and installations.";
      homepage = "https://unity3d.com/";
      license = licenses.unfree;
      maintainers = with maintainers; [ ];
      platforms = [ "x86_64-linux" ];
    };

  };
in
  {
    config = {
      environment.systemPackages = [ unityhub ];
    };
  }
