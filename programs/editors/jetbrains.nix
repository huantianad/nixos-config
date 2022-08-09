{ config, pkgs, lib, inputs, ... }:

{
  config = {
    environment.systemPackages = with pkgs.jetbrains; [
      rider
      # clion
    ];
  };
}
