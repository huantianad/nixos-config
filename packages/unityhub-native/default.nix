{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, gtk3
, perl
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "unityhub-native";
  version = "1.53";

  src = fetchFromGitHub {
    owner = "Ravbug";
    repo = "UnityHubNative";
    rev = version;
    sha256 = "sha256-UDHAhrtYKmDL3p62B0yqLeES9KTH01HMenG4CwRBXw0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    gtk3
    perl
    python3 # Needed for mbedtls code gen
    wrapGAppsHook
  ];

  patches = [
    ./patch.patch
  ];

  meta = with lib; {
    description = "Unofficial native alternative to the heavy Electron Unity Hub, written in C++";
    homepage = "https://github.com/Ravbug/UnityHubNative";
    downloadPage = "https://github.com/Ravbug/UnityHubNative/releases";
    changelog = "https://github.com/Ravbug/UnityHubNative/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
  };
}
