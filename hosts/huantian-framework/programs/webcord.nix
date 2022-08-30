{ config, pkgs, lib, inputs, ... }:

{
  config = {
    environment.systemPackages = [
      inputs.webcord.packages.${pkgs.system}.default
    ];
  };
}
