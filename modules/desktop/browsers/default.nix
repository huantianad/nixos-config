{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
{
  config = {
    environment.systemPackages = with pkgs; [ chromium ];

    nixpkgs.config.chromium.commandLineArgs = mkIf config.modules.desktop.wayland.enable
      "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  };
}
