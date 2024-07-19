{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  SDL2,
  alsa-lib,
  copyDesktopItems,
  icoutils,
  makeDesktopItem,
}:
buildDotnetModule rec {
  pname = "tjaplayer3-f";
  version = "1.8.2.1";

  src = fetchFromGitHub {
    owner = "Mr-Ojii";
    repo = pname;
    rev = "Ver.${version}";
    sha256 = "sha256-jR1/7Pgq8SDQwFMg4/WFr1gV8IF/Z8NrDFYYLRCoEcg=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  nugetDeps = ./deps.nix;

  runtimeDeps = [
    SDL2
    alsa-lib
  ];

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
  ];

  patches = [./patch.patch];

  postFixup = ''
    # This used to happen at runtime, but is removed in the patch.
    cp $out/lib/tjaplayer3-f/Libs/linux-x64/* $out/lib/tjaplayer3-f/
    rm -rf $out/lib/tjaplayer3-f/Libs/

    # Use our own SDL2
    rm $out/lib/tjaplayer3-f/runtimes/linux-x64/native/libSDL2.so

    # Icon for the desktop file
    resolutions=(16x16 32x32 48x48 64x64 256x256)
    icotool -x $src/TJAPlayer3-f/TJAPlayer3-f.ico
    for i in ''${!resolutions[@]}; do
      index=''$((i+1))
      resolution=''${resolutions[$i]}
      mkdir -p $out/share/icons/hicolor/$resolution/apps/
      cp TJAPlayer3-f_''${index}_''${resolution}x32.png $out/share/icons/hicolor/$resolution/apps/TJAPlayer3-f.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "TJAPlayer3-f";
      name = "TJAPlayer3-f";
      exec = "TJAPlayer3-f";
      icon = "TJAPlayer3-f";
      comment = meta.description;
      type = "Application";
      categories = ["Game"];
    })
  ];

  meta = with lib; {
    description = "A .tja file player (feat. DTXMania & TJAPlayer2 forPC & TJAPlayer3)";
    homepage = "https://github.com/Mr-Ojii/TJAPlayer3-f";
    downloadPage = "https://github.com/Mr-Ojii/TJAPlayer3-f/releases";
    changelog = "https://github.com/Mr-Ojii/TJAPlayer3-f/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [huantian];
    mainPrograms = "TJAPlayer3-f";
    platforms = platforms.linux;
  };
}
