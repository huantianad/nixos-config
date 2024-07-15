{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.programs.fcitx;
in
{
  options.modules.desktop.programs.fcitx = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [ fcitx5-chinese-addons ];
        waylandFrontend = config.modules.desktop.wayland.enable;
      };
    };
  };
}
