{ pkgs }:

let callPackage = pkgs.callPackage;
in {
  archipelago = callPackage ./archipelago { };

  breath-theme = pkgs.libsForQt5.callPackage ./breath-theme { };

  discord-screenaudio = pkgs.libsForQt5.callPackage ./discord-screenaudio { };

  flatpak-xdg-utils = callPackage ./flatpak-xdg-utils { };

  jetbrains-toolbox = callPackage ./jetbrains-toolbox { };

  musescore3 = pkgs.libsForQt5.callPackage ./musescore3 { };

  r2modman = callPackage ./r2modman { };

  tjaplayer3-f = callPackage ./tjaplayer3-f { };

  unityhub = callPackage ./unityhub { };

  unityhub-native = callPackage ./unityhub-native { };

  webcord = callPackage ./webcord { };

  xmage = callPackage ./xmage { };
}
