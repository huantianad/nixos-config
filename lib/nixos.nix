{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;
{
  mkHost = path: attrs @ { nixpkgs, unstable, system, mkPkgs, home-manager, ... }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit lib inputs system;
        unstable = mkPkgs unstable system;
      };
      modules = [
        {
          nixpkgs.pkgs = mkPkgs nixpkgs system;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        home-manager.nixosModules.home-manager
        (filterAttrs (n: v: !elem n [ "nixpkgs" "unstable" "system" "mkPkgs" "home-manager" ]) attrs)
        ../. # /default.nix
        (import path)
      ];
    };

  mapHosts = dir: attrs @ { nixpkgs, unstable, system, mkPkgs, home-manager, ... }:
    mapModules dir
      (hostPath: mkHost hostPath attrs);
}
