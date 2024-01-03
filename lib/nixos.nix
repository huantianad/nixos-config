{ inputs, lib, pkgs, ... }:

let
  inherit (lib) mkDefault removeSuffix;
  inherit (lib.my) mapModules;

  # nixosSystem: the flake system builder, accessed from the nixpkgs flake using nixpkgs.lib.nixosSystem
  mkHost = path: { nixosSystem, system, home-manager, overlays }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs; };
      modules = [
        {
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
          nixpkgs.overlays = overlays;
        }
        home-manager.nixosModules.home-manager
        (import path)
        ../. # /default.nix
      ];
    };
in
{
  mapHosts = dir: attrs:
    mapModules dir
      (hostPath: mkHost hostPath attrs);
}
