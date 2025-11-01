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
        serif = ["Noto Serif" "Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK JP"];
        sansSerif = ["Noto Sans" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK JP"];
        monospace = ["Monaspace Neon Var"];
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:font.dtd">
        <fontconfig>
          <description>Enable all ligatures and healing for Monaspace systemwide</description>
          <match target="font">
            <test name="fontformat" compare="not_eq">
              <string />
            </test>
            <test name="family" compare="contains">
              <string>Monaspace</string>
            </test>
            <edit name="fontfeatures" mode="append">
              <string>calt off</string>
              <string>liga on</string>
              <string>ss01 on</string>
              <string>ss02 on</string>
              <string>ss03 on</string>
              <string>ss04 on</string>
              <string>ss05 on</string>
              <string>ss06 off</string>
              <string>ss07 on</string>
              <string>ss08 on</string>
              <string>ss09 on</string>
              <string>ss10 on</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };
}
