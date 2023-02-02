{ lib, stdenv, python3, fetchFromGitHub, patchelf }:

let
  bsdiff4 = python3.pkgs.buildPythonApplication rec {
    pname = "bsdiff4";
    version = "1.2.2";

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-GICsP1KmxGrmvMbbEX5Ps1+bDM1a91/U/uaQfQDWmDw=";
    };

    meta = with lib; {
      description = "Binary diff and patch using the BSDIFF4-format";
      homepage = "https://pypi.org/project/bsdiff4/";
      license = licenses.bsd;
      maintainers = with maintainers; [ huantian ];
      platforms = [ "x86_64-linux" ];
    };
  };

in stdenv.mkDerivation rec {
  pname = "archipelago";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "ArchipelagoMW";
    repo = "Archipelago";
    rev = version;
    sha256 = "sha256-Mi/wjaY/opa982YHh74WDYZiKuK9fJLoOMsRBg9ROwY=";
  };

  nativeBuildInputs = [
    patchelf
  ];

  propagatedBuildInputs = with python3.pkgs; [
    colorama
    websockets
    pyyaml
    jellyfish
    jinja2
    schema
    kivy
    bsdiff4

    cx_Freeze
  ];
}