{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.rider;

  rider-fhs = pkgs.buildFHSUserEnv {
    name = "rider-fhs";
    runScript = "";

    targetPkgs = pkgs: with pkgs; [
      dotnetCorePackages.sdk_6_0
      dotnetPackages.Nuget
      mono
      msbuild

      # Personal development stuff
      xorg.libX11

      # Rider Unity debugging
      xorg.libXcursor
      libglvnd
    ];
  };

  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
    postInstall = ''
      # wrap rider in my custom fhs which has some dependencies
      mv $out/bin/rider $out/bin/.rider-unwrapped
      makeWrapper ${rider-fhs}/bin/rider-fhs $out/bin/rider \
        --argv0 rider \
        --add-flags $out/bin/.rider-unwrapped

      ## Making Unity Rider plugin work!
      # unity plugins looks for a build.txt at ../../build.txt, relative to binary
      # same for the product-info.json, both are used for BuildVersion and Numbers
      #ln -s $out/rider/build.txt $out/
      #ln -s $out/rider/product-info.json $out/

      # looks for ../../plugins/rider-unity, relative to binary
      # it needs some dll file in there, which it uses to bind to rider
      #ln -s $out/rider/plugins $out/plugins

      shopt -s extglob
      ln -s $out/rider/!(bin) $out/
      shopt -u extglob
    '' + attrs.postInstall or "";
  });
in
{
  options.modules.editors.rider = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ rider ];

    # unity looks for rider binary path in this location, trick it!
    home-manager.users.huantian.home.file = {
      ".local/share/applications/jetbrains-rider.desktop".text = ''
        Exec="${rider}/bin/rider"
      '';
    };
  };
}
