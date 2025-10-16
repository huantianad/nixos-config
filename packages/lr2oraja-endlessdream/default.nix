{
  lib,
  stdenv,
  jdk17,
  xrandr,
  openal,
  libjportaudio,
  egl-wayland,
  libGL,
  writeShellScript,
  fetchurl,
  fetchzip,
  makeWrapper,
  addDriverRunpath,
}: let
  beatoraja-version = "0.8.8";
  lr2oraja-version = "0.3.0";

  jdkFx = jdk17.override {enableJavaFX = true;};
  binPath = lib.makeBinPath [xrandr];
  libPath = lib.makeLibraryPath [openal libjportaudio egl-wayland libGL];

  startupScript = writeShellScript "beatoraja.sh" ''
    export _JAVA_OPTIONS="'-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel' -Dfile.encoding=UTF8"
    dataDir="''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"
    if [ ! -d "$dataDir" ]; then
      mkdir -p "$dataDir"
      cp -r $out/opt/beatoraja/* "$dataDir"
      find "$dataDir" -type f -exec chmod 644 {} \;
      find "$dataDir" -type d -exec chmod 755 {} \;
    fi
    cd "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"
    exec ${jdkFx}/bin/java -Xms1G -Xmx4G -cp $out/opt/beatoraja/beatoraja.jar:ir/* bms.player.beatoraja.MainLoader $@
  '';

  lr2oraja-jar = fetchurl {
    url = "https://github.com/seraxis/lr2oraja-endlessdream/releases/download/v${lr2oraja-version}/lr2oraja-${beatoraja-version}-endlessdream-linux-${lr2oraja-version}.jar";
    hash = "sha256-x3cZ5b5fZQdVKX6Df44m35mGYtBmM0FTxj4hm8A6hR0=";
  };
in
  stdenv.mkDerivation {
    pname = "lr2oraja-endlessdream";
    version = lr2oraja-version;

    src = fetchzip {
      url = "https://mocha-repository.info/download/beatoraja${beatoraja-version}-modernchic.zip";
      hash = "sha256-aw5jvYccH+Mnus2G9f7hTAMuC+HdjR6I8pzYDrOm98E=";
    };

    nativeBuildInputs = [makeWrapper];

    preInstall = ''
      rm beatoraja-config.bat
      rm beatoraja-config.command
      rm jportaudio_x64.dll
      rm portaudio_x64.dll
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/beatoraja
      mkdir -p $out/bin
      ln -s ${startupScript} $out/bin/beatoraja
      mv * $out/opt/beatoraja/

      cp ${lr2oraja-jar} $out/opt/beatoraja/beatoraja.jar

      wrapProgram $out/bin/beatoraja \
        --set out $out \
        --suffix PATH : "${binPath}" \
        --prefix LD_LIBRARY_PATH : "${addDriverRunpath.driverLink}/lib:${libPath}" \

      runHook postInstall
    '';

    meta = with lib; {
      description = "Cross-platform rhythm game based on Java and libGDX.";
      homepage = "https://github.com/exch-bms2/beatoraja";
      license = [licenses.gpl3Only "unknown"];
      platforms = ["x86_64-linux"];
      mainProgram = "beatoraja";
      sourceProvenance = with sourceTypes; [binaryBytecode];
    };
  }
