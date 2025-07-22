{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.fonts;
in {
  options.modules.desktop.fonts = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      # General Fonts
      corefonts

      # Monospace fonts
      fira-code
      jetbrains-mono
      monaspace

      # CJK Fonts
      source-han-serif
      source-han-sans
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      wqy_zenhei
      wqy_microhei
    ];

    fonts.fontconfig = {
      includeUserConf = false;
      subpixel.rgba = "none";
      defaultFonts = {
        serif = ["Noto Serif" "Source Han Serif SC" "Source Han Serif TC" "Source Han Serif JP"];
        sansSerif = ["Noto Sans" "Source Han Sans SC" "Source Han Sans TC" "Source Han Sans JP"];
        monospace = ["Monaspace Neon"];
      };
    };
  };
}
