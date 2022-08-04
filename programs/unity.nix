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
      autoPatchelfHook
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
    ];

    libPath = with pkgs; lib.makeLibraryPath [
      libva
      openssl_3
      openssl
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

      # `unityhub` is a shell wrapper that runs `unityhub-bin`
      # We don't need this so we can replace it with the binary directly.
      rm $out/opt/unityhub/unityhub
      mv $out/opt/unityhub/unityhub-bin $out/opt/unityhub/unityhub

      # Link binary
      ln -s $out/opt/unityhub/unityhub $out/bin/unityhub

      # Replace absolute path to correctly point to nix store
      substituteInPlace $out/share/applications/unityhub.desktop \
        --replace /opt/unityhub/unityhub $out/opt/unityhub/unityhub

      wrapProgramShell $out/opt/unityhub/unityhub \
        --prefix LD_LIBRARY_PATH : ${libPath}

      # From the .deb's postinst hook, not sure if necessary
      chmod 4755 '$out/opt/unityhub/chrome-sandbox' || true

      runHook postInstall
    '';

    dontStrip = true;

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
