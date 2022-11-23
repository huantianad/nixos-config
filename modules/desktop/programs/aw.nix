{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.programs.aw;
in
{
  options.modules.desktop.programs.aw = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with inputs.jtoinar.legacyPackages.${pkgs.system}; [
      aw-qt
      aw-server-rust
      aw-watcher-afk
      aw-watcher-window
      inputs.aw-watcher-custom.packages.${pkgs.system}.default
    ];
  };
}
