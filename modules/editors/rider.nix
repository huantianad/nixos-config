{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.rider;

  dotnetCombined = with pkgs.dotnetCorePackages;
    combinePackages [ sdk_6_0 ];

  rider-fhs = pkgs.buildFHSUserEnv {
    name = "rider-fhs";
    runScript = "";
    targetPkgs = pkgs: with pkgs; [
      dotnetCombined
      dotnetPackages.Nuget
      mono
      msbuild
    ];
  };

  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
    postInstall = ''
      # wrap rider in my custom fhs which has some dependencies
      mv $out/bin/rider $out/bin/.rider-unwrapped

      cat >$out/bin/rider <<EOL
      #!${pkgs.bash}/bin/bash
      ${rider-fhs}/bin/rider-fhs $out/bin/.rider-unwrapped "\$@"
      EOL

      chmod +x $out/bin/rider

      ## Making Unity Rider plugin work!
      # unity plugins looks for a build.txt at ../../build.txt, relative to binary
      # same for hte product-info.json, both are used for BuildVersion and Numbers
      ln -s $out/rider/build.txt $out/
      ln -s $out/rider/product-info.json $out/

      # looks for ../../plugins/rider-unity, relative to binary
      # it needs some dll file in there, which it uses to bind to rider
      ln -s $out/rider/plugins $out/plugins
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
