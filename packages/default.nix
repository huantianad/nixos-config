{ pkgs }:

let callPackage = pkgs.callPackage;
in {
  musescore3 = pkgs.libsForQt5.callPackage ./musescore3 { };

  tjaplayer3-f = callPackage ./tjaplayer3-f { };

  unityhub-native = callPackage ./unityhub-native { };

  unnamed-sdvx-clone = callPackage ./unnamed-sdvx-clone { };

  xmage = callPackage ./xmage { };
}
