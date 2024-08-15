{
  lib,
  stdenv,
  fetchFromGitHub,
  kissfft,
  miniaudio,
  pkg-config,
  python3Packages,
  gobject-introspection,
  ffmpeg,
  flac,
  game-music-emu,
  gtk3,
  libappindicator,
  libnotify,
  libopenmpt,
  librsvg,
  libsamplerate,
  libvorbis,
  mpg123,
  opusfile,
  pango,
  pipewire,
  wavpack,
  pulseaudio,
  withDiscordRPC ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tauon";
  version = "unstable-2024-08-14";

  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "TauonMusicBox";
    rev = "361eb16f92d3984d29726545ccd5b37fa6fcaca5";
    hash = "sha256-UVluO7VVJiC/atdSeww9jK/8yd9/srSM57CGl5rdT/k=";
  };

  postUnpack = ''
    rmdir source/src/phazor/kissfft
    ln -s ${kissfft.src} source/src/phazor/kissfft

    rmdir source/src/phazor/miniaudio
    ln -s ${miniaudio.src} source/src/phazor/miniaudio
  '';

  postPatch = ''
    substituteInPlace tauon.py \
      --replace-fail 'install_mode = False' 'install_mode = True' \
      --replace-fail 'install_directory = os.path.dirname(os.path.abspath(__file__))' 'install_directory = "${placeholder "out"}/share/tauon"'

    substituteInPlace t_modules/t_main.py \
      --replace-fail 'install_mode = False' 'install_mode = True' \
      --replace-fail 'libopenmpt.so' '${lib.getLib libopenmpt}/lib/libopenmpt.so'

    substituteInPlace t_modules/t_phazor.py \
      --replace 'lib/libphazor' '../../lib/libphazor'

    substituteInPlace compile-phazor*.sh --replace-fail 'gcc' '${stdenv.cc.targetPrefix}cc'

    substituteInPlace extra/tauonmb.desktop --replace-fail 'Exec=/opt/tauon-music-box/tauonmb.sh' 'Exec=${placeholder "out"}/bin/tauon'
  '';

  postBuild = ''
    bash ./compile-phazor.sh
    bash ./compile-phazor-pipewire.sh
  '';

  nativeBuildInputs = [
    pkg-config
    python3Packages.wrapPython
    gobject-introspection
  ];

  buildInputs = [
    flac
    game-music-emu
    gtk3
    libappindicator
    libnotify
    libopenmpt
    librsvg
    libsamplerate
    libvorbis
    mpg123
    opusfile
    pango
    pipewire
    wavpack
  ];

  pythonPath =
    with python3Packages;
    [
      beautifulsoup4
      dbus-python
      unidecode
      musicbrainzngs
      mutagen
      natsort
      pillow
      plexapi
      pycairo
      pychromecast
      pylast
      pygobject3
      pysdl2
      requests
      send2trash
      setproctitle
    ]
    ++ lib.optional withDiscordRPC pypresence
    ++ lib.optional stdenv.isLinux pulsectl;

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}"
    "--prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        game-music-emu
        pulseaudio
      ]
    }"
    "--prefix PYTHONPATH : $out/share/tauon"
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
  ];

  installPhase = ''
    install -Dm755 tauon.py $out/bin/tauon
    mkdir -p $out/share/tauon
    cp -r lib $out
    cp -r assets input.txt t_modules theme templates $out/share/tauon

    wrapPythonPrograms

    mkdir -p $out/share/applications
    install -Dm755 extra/tauonmb.desktop $out/share/applications/tauonmb.desktop
    mkdir -p $out/share/icons/hicolor/scalable/apps
    install -Dm644 extra/tauonmb{,-symbolic}.svg $out/share/icons/hicolor/scalable/apps
  '';

  meta = with lib; {
    description = "Linux desktop music player from the future";
    mainProgram = "tauon";
    homepage = "https://tauonmusicbox.rocks/";
    changelog = "https://github.com/Taiko2k/TauonMusicBox/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jansol ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
