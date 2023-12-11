{ pkgs }:

pkgs.lib.makeScope pkgs.newScope (self:
let
  callPackage = self.callPackage;
in
{
  musescore3 = pkgs.libsForQt5.callPackage ./musescore3 { };

  prismlauncher = pkgs.qt6.callPackage ./prismlauncher { };

  tjaplayer3-f = callPackage ./tjaplayer3-f { };

  unityhub-native = callPackage ./unityhub-native { };

  unnamed-sdvx-clone = callPackage ./unnamed-sdvx-clone { };

  xmage = callPackage ./xmage { };
}
)
