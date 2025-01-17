{
  lib,
  stdenv,
  fetchzip,
  fetchurl,
  jdk,
  libjportaudio,
  makeWrapper,
  openal,
  writeShellScript,
  xrandr,
}: let
  pname = "lr2oraja-endlessdream";
  version = "0.8.8";
  fullName = "beatoraja${version}-modernchic";

  jdkFx = jdk.override {enableJavaFX = true;};
  binPath = lib.makeBinPath [xrandr];
  libPath = lib.makeLibraryPath [openal libjportaudio];

  startupScript = writeShellScript "beatoraja.sh" ''
    export _JAVA_OPTIONS='-Dsun.java2d.opengl=true -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dfile.encoding=UTF8'
    dataDir="''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"
    if [ ! -d "$dataDir" ]; then
      mkdir -p "$dataDir"
      cp -r $out/opt/beatoraja/* "$dataDir"
      find "$dataDir" -type f -exec chmod 644 {} \;
      find "$dataDir" -type d -exec chmod 755 {} \;
    fi
    cd "''${XDG_DATA_HOME:-$HOME/.local/share}/beatoraja"
    exec ${jdkFx}/bin/java -Xms1G -Xmx4G -jar $out/opt/beatoraja/beatoraja.jar $@
  '';

  lr2oraja-jar = fetchurl {
    url = "https://github.com/seraxis/lr2oraja-endlessdream/releases/download/v0.2.1/lr2oraja-0.8.7-endlessdream-linux-0.2.1.jar";
    hash = "sha256-czkFZP3gn9ieq5w6NLCvvSTufgesFhtD7YGEwyD3HYs=";
  };
in
  stdenv.mkDerivation {
    inherit pname version;
    name = "${pname}-${version}";
    src = fetchzip {
      url = "https://mocha-repository.info/download/${fullName}.zip";
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
        --prefix LD_LIBRARY_PATH : "${libPath}" \

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
