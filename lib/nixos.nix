{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;
{
  # nixpkgs: the nixpkgs flake
  # unstable: an `import`ed nixpkgs-unstable, for this system
  # system: system string
  # home-manager: the home-manager flake
  # overlays: list of overlays to use
  mkHost = path: attrs @ { nixpkgs, unstable, system, home-manager, overlays, ... }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system unstable; nixpkgs-flake = nixpkgs; };
      modules = [
        {
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
          nixpkgs.overlays = overlays;
        }
        (filterAttrs (n: v: !elem n [ "nixpkgs" "unstable" "system" "home-manager" "overlays" ]) attrs)
        home-manager.nixosModules.home-manager
        ../. # /default.nix
        (import path)
      ];
    };

  mapHosts = dir: attrs @ { nixpkgs, unstable, system, home-manager, overlays, ... }:
    mapModules dir
      (hostPath: mkHost hostPath attrs);
}
