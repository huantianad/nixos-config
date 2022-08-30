{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.fonts;
in
{
  options.modules.desktop.fonts = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    fonts.fonts = with pkgs; [
      liberation_ttf
      fira-code

      # Some CJK Fonts
      source-han-serif
      source-han-sans
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };
}
