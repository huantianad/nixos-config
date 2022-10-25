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
      kate
      element-desktop
      ark
      # ark already comes with this, but we need it for dolphin extracting
      p7zip
      unrar
      vlc
      gimp
      qbittorrent
      zoom-us
      baobab
      libreoffice-qt
      kalendar
      audacity
      obs-studio
      kid3
      soulseekqt
      obsidian
      ffmpeg_5
    ];
  };
}
