{
  description = "My amazing NixOS config! Very WIP.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    powercord-overlay.inputs.nixpkgs.follows = "nixpkgs";

    powercord-better-replies = { url = "github:12944qwerty/better-replies"; flake = false; };
    powercord-double-click-vc = { url = "github:discord-modifications/double-click-vc"; flake = false; };
    powercord-mute-new-guild = { url = "github:RazerMoon/muteNewGuild"; flake = false; };
    powercord-no-double-back-pc = { url = "github:the-cord-plug/no-double-back-pc"; flake = false; };
    powercord-remove-invite-from-user-context-menu = { url = "github:SebbyLaw/remove-invite-from-user-context-menu"; flake = false; };
    powercord-screenshare-crack = { url = "github:discord-modifications/screenshare-crack"; flake = false; };
    powercord-unindent = { url = "github:VenPlugs/Unindent"; flake = false; };
    powercord-vpc-shiki = { url = "github:Vap0r1ze/vpc-shiki"; flake = false; };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    declarative-cachix.url = "github:jonascarpay/declarative-cachix";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
  {
    nixosConfigurations = {
      huantian-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
