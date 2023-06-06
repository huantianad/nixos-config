{
  description = "My amazing NixOS config! Very WIP.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    aw-watcher-custom.url = "github:huantianad/aw-watcher-custom";
    aw-watcher-custom.inputs.nixpkgs.follows = "nixpkgs";

    nixinate.url = "github:matthewcroughan/nixinate";
    nixinate.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs = pkgsArg: systemArg: import pkgsArg {
        system = systemArg;
        config.allowUnfree = true;
        overlays = [ self.overlay ] ++ (lib.attrValues self.overlays);
      };

      pkgs = mkPkgs nixpkgs system;

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit pkgs inputs; lib = self; };
      });
    in
    {
      lib = lib.my;

      nixosModules = mapModulesRec ./modules import;

      nixosConfigurations =
        mapHosts ./hosts/unstable/x86_64-linux { nixpkgs = nixpkgs; system = "x86_64-linux"; mkPkgs = mkPkgs; }
        // mapHosts ./hosts/stable/x86_64-linux { nixpkgs = inputs.nixpkgs-stable; system = "x86_64-linux"; mkPkgs = mkPkgs; }
        // mapHosts ./hosts/stable/aarch64-linux { nixpkgs = inputs.nixpkgs-stable; system = "aarch64-linux"; mkPkgs = mkPkgs; };

      apps = inputs.nixinate.nixinate."${system}" self;

      packages."${system}" = import ./packages { inherit pkgs; };

      overlay = final: prev: {
        my = self.packages."${system}";
      };

      overlays = mapModules ./overlays import;
    };
}
