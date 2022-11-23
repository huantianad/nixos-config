{
  description = "My amazing NixOS config! Very WIP.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    webcord.url = "github:fufexan/webcord-flake";
    webcord.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    # activitywatch
    jtoinar.url = "github:jtojnar/nixfiles";
    jtoinar.inputs.nixpkgs.follows = "nixpkgs";

    aw-watcher-custom.url = "github:huantianad/aw-watcher-custom";
    aw-watcher-custom.inputs.nixpkgs.follows = "nixpkgs";

    nixinate.url = "github:matthewcroughan/nixinate";
    nixinate.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ self.overlay ];
      };

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit pkgs inputs; lib = self; };
      });
    in
    {
      lib = lib.my;

      overlay = final: prev: {
        my = self.packages."${system}";
      };

      nixosModules = mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };

      apps = inputs.nixinate.nixinate."${system}" self;

      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p { });
    };
}
