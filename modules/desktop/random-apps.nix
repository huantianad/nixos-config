{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.random-apps;
in
{
  options.modules.desktop.random-apps = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vesktop
      kitty
      vlc
      mpv
      soundfont-generaluser # for vlc midi

      element-desktop
      cinny-desktop
      gimp
      qbittorrent
      deluge-gtk
      libreoffice-qt
      audacity
      obs-studio
      kid3
      kooha
      musescore
      # my.musescore3
      jellyfin-media-player
      qpwgraph
      newsflash
      easyeffects
      kicad-small
      inkscape

      # soulseekqt
      # bitwarden
      # obsidian

      kdePackages.merkuro
      kdePackages.filelight
      kdePackages.ark
      # ark already comes with this, but we need it for dolphin extracting
      p7zip
      unrar

      # Command-line apps
      yt-dlp
      ffmpeg-full
      nixpkgs-review
      wineWowPackages.staging
      winetricks
    ];
  };
}
