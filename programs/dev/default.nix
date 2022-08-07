{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./direnv.nix
  ];

  config = {
    enviornment.systemPackages = with pkgs; [
      gcc
    ];
  };
}
