{
  description = "My amazing NixOS config! Very WIP.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    aw.url = "github:huantianad/nixpkgs/activitywatch";
    aw-watcher-custom.url = "github:huantianad/aw-watcher-custom";

    nixinate.url = "github:matthewcroughan/nixinate";
    nixinate.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      inherit (lib.my) mapModulesRec mapHosts;

      system = "x86_64-linux";
      system-arm = "aarch64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ self.overlay ];
      };

      arm-pkgs = import nixpkgs {
        system = system-arm;
        config.allowUnfree = true;
        overlays = [ self.overlay ];
      };

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit pkgs inputs; lib = self; };
      });

      arm-lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; pkgs = arm-pkgs; lib = self; };
      });
    in
    {
      lib = lib.my;

      overlay = final: prev: {
        my = self.packages."${system}";
      };

      nixosModules = mapModulesRec ./modules import;

      nixosConfigurations = (mapHosts ./hosts { })
        // (arm-lib.my.mapHosts ./arm-hosts { system = system-arm; });

      apps = inputs.nixinate.nixinate."${system}" self;

      packages."${system}" = import ./packages { inherit pkgs; };
    };
}
