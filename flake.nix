{
  description = "My amazing NixOS config! Very WIP.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    nixos-hardware.url = "github:huantianad/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-stable.url = "github:nix-community/home-manager/release-24.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    aw-watcher-custom.url = "github:huantianad/aw-watcher-custom";
    aw-watcher-custom.inputs.nixpkgs.follows = "nixpkgs";

    nixinate.url = "github:matthewcroughan/nixinate";
    nixinate.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    minifluxng.url = "sourcehut:~bwolf/miniflux.nix";
    minifluxng.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    glaumar.url = "github:glaumar/nur";
    glaumar.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    defaultSystem = "x86_64-linux";

    allOverlays = [self.overlay] ++ (lib.attrValues self.overlays);

    mkPkgs = pkgsArg: systemArg:
      import pkgsArg {
        system = systemArg;
        config.allowUnfree = true;
        overlays = allOverlays;
      };

    pkgs = mkPkgs nixpkgs defaultSystem;

    lib = nixpkgs.lib.extend (self: super: {
      my = import ./lib {
        inherit pkgs inputs;
        lib = self;
      };
    });

    mapHosts = path: nixpkgsType: system: let
      table =
        {
          unstable = {
            nixpkgs = nixpkgs;
            home-manager = inputs.home-manager;
          };
          stable = {
            nixpkgs = inputs.nixpkgs-stable;
            home-manager = inputs.home-manager-stable;
          };
        }
        .${nixpkgsType};

      thisPkgs = mkPkgs table.nixpkgs system;
      thisLib = table.nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit inputs;
          pkgs = thisPkgs;
          lib = self;
        };
      });
    in
      thisLib.my.mapHosts path
      {
        nixosSystem = table.nixpkgs.lib.nixosSystem;
        system = system;
        home-manager = table.home-manager;
        overlays = allOverlays;
      };
  in {
    lib = lib.my;

    nixosModules = lib.my.mapModulesRec ./modules import;

    nixosConfigurations =
      (mapHosts ./hosts/unstable/x86_64-linux "unstable" "x86_64-linux")
      // (mapHosts ./hosts/stable/x86_64-linux "stable" "x86_64-linux")
      // (mapHosts ./hosts/stable/aarch64-linux "stable" "aarch64-linux");

    apps = inputs.nixinate.nixinate."${defaultSystem}" self;

    packages."${defaultSystem}" = import ./packages {inherit pkgs;};

    overlay = final: prev: {
      my = self.packages."${defaultSystem}";
    };

    overlays = lib.my.mapModules ./overlays import;
  };
}
