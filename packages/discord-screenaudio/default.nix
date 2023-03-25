{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, qtbase
, qtwebengine
, knotifications
, kxmlgui
, kglobalaccel
, pipewire
, xdg-desktop-portal
, pulseaudio
, libpulseaudio
, systemd
}:

stdenv.mkDerivation rec {
  pname = "discord-screenaudio";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "maltejur";
    repo = "discord-screenaudio";
    rev = "v${version}";
    sha256 = "sha256-3bYxD3MAzAvwsqtH5D1EoeTzN0Nd/ZM+ZU1CnMa2FZo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    qtbase
    qtwebengine
    knotifications
    kxmlgui
    kglobalaccel
  ];

  buildInputs = [
    pipewire
    pipewire.pulse
    xdg-desktop-portal
    pulseaudio
    libpulseaudio
    systemd
  ];

  libPath = lib.makeLibraryPath [
    pipewire
    pipewire.pulse
    xdg-desktop-portal
    pulseaudio
    libpulseaudio
    systemd
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${pipewire.dev}/include/pipewire-0.3"
    "-I${pipewire.dev}/include/spa-0.2"
    "-Wno-pedantic"
  ];

  postFixup = ''
    wrapProgram $out/bin/discord-screenaudio \
      --suffix PATH : "${lib.makeBinPath [ pulseaudio ]}" \
      --prefix LD_LIBRARY_PATH : ${libPath}
  '';

  meta = with lib; {
    description = "A custom discord client that supports streaming with audio on Linux";
    homepage = "https://github.com/maltejur/discord-screenaudio";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ huantian ];
    platforms = platforms.linux;
  };
}
