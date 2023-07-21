{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.rider;

  extra-path = with pkgs; [
    dotnetCorePackages.sdk_6_0
    dotnetPackages.Nuget
    mono
    msbuild
  ];

  extra-lib = with pkgs;[
    # Personal development stuff
    xorg.libX11

    # Rider Unity debugging
    xorg.libXcursor
    xorg.libXrandr
    libglvnd
  ];

  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
    postInstall = ''
      # Wrap rider with extra tools and libraries
      mv $out/bin/rider $out/bin/.rider-unwrapped
      makeWrapper $out/bin/.rider-unwrapped $out/bin/rider \
        --argv0 rider \
        --prefix PATH : "${lib.makeBinPath extra-path}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}"

      # Making Unity Rider plugin work!
      # The plugin expects the binary to be at /rider/bin/rider, with bundled files at /rider/
      # It does this by going up one directory from the directory the binary is in
      # We have rider binary at $out/bin/rider, so we need to link /rider/ to $out/
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
