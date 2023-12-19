{
  description = "My amazing NixOS config! Very WIP.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    aw-watcher-custom.url = "github:huantianad/aw-watcher-custom";
    aw-watcher-custom.inputs.nixpkgs.follows = "nixpkgs";

    nixinate.url = "github:matthewcroughan/nixinate";
    nixinate.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    minifluxng.url = "sourcehut:~bwolf/miniflux.nix";
    minifluxng.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-matlab.url = "gitlab:doronbehar/nix-matlab";
    nix-matlab.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      allOverlays = [ self.overlay ] ++ (lib.attrValues self.overlays);

      mkPkgs = pkgsArg: systemArg: import pkgsArg {
        system = systemArg;
        config.allowUnfree = true;
        overlays = allOverlays;
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
        mapHosts ./hosts/unstable/x86_64-linux
          {
            nixpkgs = nixpkgs;
            unstable = pkgs;
            system = "x86_64-linux";
            home-manager = inputs.home-manager;
            overlays = allOverlays;
          }
        // mapHosts ./hosts/stable/x86_64-linux
          {
            nixpkgs = inputs.nixpkgs-stable;
            unstable = pkgs;
            system = "x86_64-linux";
            home-manager = inputs.home-manager-stable;
            overlays = allOverlays;
          }
        // mapHosts ./hosts/stable/aarch64-linux
          {
            nixpkgs = inputs.nixpkgs-stable;
            unstable = mkPkgs nixpkgs "aarch64-linux";
            system = "aarch64-linux";
            home-manager = inputs.home-manager-stable;
            overlays = allOverlays;
          };

      apps = inputs.nixinate.nixinate."${system}" self;

      packages."${system}" = import ./packages { inherit pkgs; };

      overlay = final: prev: {
        my = self.packages."${system}";
      };

      overlays = mapModules ./overlays import;
    };
}
