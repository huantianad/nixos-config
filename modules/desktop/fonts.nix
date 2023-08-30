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
      # General Fonts
      liberation_ttf
      corefonts

      # Monospace fonts
      fira-code
      jetbrains-mono
      meslo-lgs-nf # Font for p10k theme

      # CJK Fonts
      source-han-serif
      source-han-sans
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };
}
