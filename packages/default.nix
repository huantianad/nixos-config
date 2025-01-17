{pkgs}:
pkgs.lib.makeScope pkgs.newScope (
  self: let
    callPackage = self.callPackage;
  in {
    libjportaudio = callPackage ./libjportaudio {};

    lr2oraja-endlessdream = callPackage ./lr2oraja-endlessdream {};

    musescore3 = pkgs.libsForQt5.callPackage ./musescore3 {};

    tauon = callPackage ./tauon {};

    tjaplayer3-f = callPackage ./tjaplayer3-f {};

    unityhub-native = callPackage ./unityhub-native {};

    unnamed-sdvx-clone = callPackage ./unnamed-sdvx-clone {};

    xmage = callPackage ./xmage {};
  }
)
