{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;
{
  mkHost = path: attrs @ { nixpkgs, system, mkPkgs, ... }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = mkPkgs nixpkgs system;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "nixpkgs" "system" "mkPkgs" ]) attrs)
        ../. # /default.nix
        (import path)
      ];
    };

  mapHosts = dir: attrs @ { nixpkgs, system, mkPkgs, ... }:
    mapModules dir
      (hostPath: mkHost hostPath attrs);
}
