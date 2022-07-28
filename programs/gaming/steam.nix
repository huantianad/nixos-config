{ config, pkgs, lib, inputs, ... }:

{
  config = {
    programs.steam.enable = true;

    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs: [
          # I think I added these libraries for Demoncrawl
          pkgs.libssh
          pkgs.brotli
        ];
      };
    };
  };
}
