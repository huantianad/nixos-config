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
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [ fcitx5-chinese-addons ];
        waylandFrontend = config.modules.desktop.wayland.enable;
      };
    };

    nixpkgs.overlays = mkIf config.modules.desktop.wayland.enable [
      (self: super: {
        # We start fcitx with kde so we don't need the autostart file.
        fcitx5-with-addons = super.fcitx5-with-addons.overrideAttrs
          (attrs: {
            postBuild = attrs.postBuild + "\nunlink $out/$autostart";
          });
        # Add the wayland ime flag to vesktop
        # TODO: Remove this when we have a better mechanism for this!
        vesktop = super.vesktop.overrideAttrs
          (attrs: {
            installPhase = replaceStrings
              [ "WaylandWindowDecorations" ]
              [ "WaylandWindowDecorations --enable-wayland-ime" ]
              attrs.installPhase;
          });
      })
    ];
  };
}
