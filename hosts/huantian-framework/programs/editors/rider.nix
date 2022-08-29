{ config, pkgs, lib, inputs, ... }:

let
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
      mv $out/bin/rider $out/bin/.rider-unwrapped

      cat >$out/bin/rider <<EOL
      #!${pkgs.bash}/bin/bash
      ${rider-fhs}/bin/rider-fhs $out/bin/.rider-unwrapped "\$@"
      EOL

      chmod +x $out/bin/rider
    '' + attrs.postInstall or "";
  });
in
{
  config = {
    environment.systemPackages = [ rider ];

    # unity looks for rider in this location, trick it!
    # doesn't seem to work with advanced unity integration yet tho.
    # I have no idea how to make it work with that, what does the plugin need?
    home-manager.users.huantian.home.file = {
      ".local/share/applications/jetbrains-rider.desktop".text = ''
        Exec="${rider}/bin/rider"
      '';
    };
  };
}
