{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./steam.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}