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
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "maltejur";
    repo = "discord-screenaudio";
    rev = "v${version}";
    hash = "sha256-dCamrgtXhbtJvn8J1GVbY2mWLC3kZUGWbKcT44ei2MU=";
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

  cmakeFlags = [
    "-DPipeWire_INCLUDE_DIRS=${pipewire.dev}/include/pipewire-0.3"
    "-DSpa_INCLUDE_DIRS=${pipewire.dev}/include/spa-0.2"
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
