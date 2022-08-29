{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./direnv.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      gcc
    ];
  };
}
