{ inputs, lib, pkgs, ... }:

let
  inherit (builtins) elem;
  inherit (lib) filterAttrs mkDefault removeSuffix;
  inherit (lib.my) mapModules;

  # nixpkgs: the nixpkgs flake
  # system: system string
  # home-manager: the home-manager flake
  # overlays: list of overlays to use
  mkHost = path: attrs @ { nixpkgs, system, home-manager, overlays, ... }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
          nixpkgs.overlays = overlays;
        }
        (filterAttrs (n: v: !elem n [ "nixpkgs" "system" "home-manager" "overlays" ]) attrs)
        home-manager.nixosModules.home-manager
        ../. # /default.nix
        (import path)
      ];
    };
in
{
  mapHosts = dir: attrs:
    mapModules dir
      (hostPath: mkHost hostPath attrs);
}
