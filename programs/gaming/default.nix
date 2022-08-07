{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./dolphin.nix
    ./steam.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      lutris
      polymc
      scarab
    ];
  };
}
