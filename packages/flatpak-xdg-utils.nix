{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, cmake, glib }:

stdenv.mkDerivation rec {
  pname = "flatpak-xdg-utils";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = "flatpak-xdg-utils";
    rev = version;
    sha256 = "sha256-TqUV8QpBti+86FElCdHXifIS2dsShA/POFUyZwjTHOE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
  ];

  buildInputs = [
    glib
  ];
}
