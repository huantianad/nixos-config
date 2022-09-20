{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.programs.unity;

  unityhub = pkgs.stdenv.mkDerivation rec {
    name = "unityhub";
    version = "3.3.0";

    src = pkgs.fetchurl {
      url = "https://hub-dist.unity3d.com/artifactory/hub-debian-prod-local/pool/main/u/unity/unityhub_amd64/unityhub-amd64-${version}.deb";
      sha256 = "sha256-W5NPOvIUFDyNuauUDXD/jaMD5USPO/7Wty6FuxtFbRk=";
    };

    nativeBuildInputs = with pkgs; [
      dpkg
      makeShellWrapper
    ];

    extraLibs = with pkgs; with xorg; [
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
      libpulseaudio # Not a ldd thing, but needed for sound to work
      nss_latest
      libdrm
      mesa
      nspr
      atk
      dbus
      at-spi2-atk
      gnome2.pango

      libva
      openssl
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

      # editor
      libglvnd #ligbl
      xorg.libX11
      xorg.libXcursor
      glib
      gdk-pixbuf
      libxml2
      zlib
      clang

      libsForQt5.full
      xorg.libXinerama
      hicolor-icon-theme
      gtk4

      # for me personally
      harfbuzz
      libogg

      # bug reporter stuff???
      fontconfig
      freetype
      lsb-release
    ];

    fhsEnv = pkgs.buildFHSUserEnv {
      name = "${name}-fhs-env";
      targetPkgs = pkgs: unityhub.extraLibs;
      runScript = "";
      extraBuildCommands = ''
        # mkdir -p $out/usr/share/glib-2.0
        # ln -s ${pkgs.glib.getSchemaPath pkgs.gtk3} $out/usr/share/glib-2.0/schemas
        mkdir -p $out/usr/lib/qt5/
        ln -s ${pkgs.libsForQt5.full}/lib/qt-5.15.5/qml $out/usr/lib/qt5/qml
        ln -s ${pkgs.libsForQt5.full}/lib/qt-5.15.5/plugins $out/usr/lib/qt5/plugins
      '';
    };

    sourceRoot = ".";
    unpackPhase = "dpkg -x $src .";

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin

      mv usr/share/ $out/share
      mv opt/ $out/opt

      # `unityhub` is a shell wrapper that runs `unityhub-bin`
      # Which we don't need and replace with our own custom wrapper later
      rm $out/opt/unityhub/unityhub

      # Link binary
      ln -s $out/opt/unityhub/unityhub $out/bin/unityhub

      # Replace absolute path to correctly point to nix store
      substituteInPlace $out/share/applications/unityhub.desktop \
        --replace /opt/unityhub/unityhub $out/opt/unityhub/unityhub

      cat >$out/opt/unityhub/unityhub <<EOL
      #!${pkgs.bash}/bin/bash
      export GDK_BACKEND=x11
      export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH:/run/opengl-driver/lib:/run/opengl-driver-32/lib:/usr/lib:/usr/lib32"
      export GSETTINGS_SCHEMA_DIR=${pkgs.glib.getSchemaPath pkgs.gtk3}
      export QML2_IMPORT_PATH="${pkgs.libsForQt5.full}/lib/qt-5.15.5/qml:\$QML2_IMPORT_PATH"
      export QT_PLUGIN_PATH="${pkgs.libsForQt5.full}/lib/qt-5.15.5/plugins:\$QT_PLUGIN_PATH"
      ${fhsEnv}/bin/${name}-fhs-env $out/opt/unityhub/unityhub-bin "\$@"
      EOL
      chmod +x $out/opt/unityhub/unityhub

      # From the .deb's postinst hook, not sure if necessary
      chmod 4755 '$out/opt/unityhub/chrome-sandbox' || true

      runHook postInstall
    '';

    dontStrip = true;

    meta = with lib; {
      description = "Download and manage Unity Projects and installations.";
      homepage = "https://unity3d.com/";
      license = licenses.unfree;
      maintainers = with maintainers; [ huantian ];
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  options.modules.desktop.programs.unity = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      unityhub
      # (pkgs.unityhub.overrideAttrs (attrs: {
      #   buildCommand = attrs.buildCommand + ''
      #     ln -s $out/bin/unityhub-2.3.2 $out/bin/unityhub
      #   '';
      # }))
    ];
  };
}
