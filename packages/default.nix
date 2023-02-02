{ pkgs }:

let callPackage = pkgs.callPackage;
in {
  archipelago = callPackage ./archipelago {};

  breath-theme = pkgs.libsForQt5.callPackage ./breath-theme {};

  flatpak-xdg-utils = callPackage ./flatpak-xdg-utils {};

  jetbrains-toolbox = callPackage ./jetbrains-toolbox {};

  r2modman = callPackage ./r2modman {};

  unityhub = callPackage ./unityhub {};

  webcord = callPackage ./webcord {};

  xdg-utils = callPackage ./xdg-utils {};

  xmage = callPackage ./xmage {};
}