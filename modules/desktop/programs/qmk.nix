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
    environment.systemPackages = [
      pkgs.qmk
      # pkgs.via
    ];

    services.udev.packages = [
      (pkgs.qmk-udev-rules.overrideAttrs (attrs: {
        version = "0.19.2";
        src = pkgs.fetchFromGitHub {
          owner = "qmk";
          repo = "qmk_firmware";
          rev = "0.25.3";
          sha256 = "sha256-7zQfA5fqxuwZXUCzlJj/Ok3PvZ4TSVZY/tIfuiauhjI=";
        };
      }))
    ];
  };
}
