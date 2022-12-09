{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.qmk;
in
{
  options.modules.desktop.programs.qmk = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qmk pkgs.via pkgs.vial ];

    services.udev.packages = [
      pkgs.via
      pkgs.vial
      (pkgs.qmk-udev-rules.overrideAttrs (attrs: {
        version = "0.19.2";
        src = pkgs.fetchFromGitHub {
          owner = "qmk";
          repo = "qmk_firmware";
          rev = "0.19.2";
          sha256 = "sha256-f/SFkO+x8aK2dmix75wCJ/ThTy/KyEzzz9FO1VP7rLw=";
        };
      }))
    ];
  };
}
