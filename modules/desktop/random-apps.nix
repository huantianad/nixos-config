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
      element-desktop
      cinny-desktop
      vlc
      soundfont-generaluser # for vlc midi
      gimp
      qbittorrent
      deluge-gtk
      baobab
      libreoffice-qt
      audacity
      obs-studio
      kid3
      peek
      my.musescore3
      jellyfin-media-player
      qpwgraph
      newsflash
      easyeffects
      kdePackages.merkuro
      vesktop
      kitty
      # soulseekqt
      # bitwarden
      # obsidian

      ark
      # ark already comes with this, but we need it for dolphin extracting
      p7zip
      unrar

      # Command-line apps
      ffmpeg_6-full
      yt-dlp
      nixpkgs-review
      wineWowPackages.staging
      winetricks
    ];
  };
}
