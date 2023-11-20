{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.pipewire;
in
{
  options.modules.hardware.pipewire = {
    enable = mkBoolOpt false;
  };

  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  config = mkIf cfg.enable {
    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true;

      wireplumber.enable = true;

      lowLatency = {
        # enable this module
        enable = true;
        # defaults (no need to be set unless modified)
        quantum = 64;
        rate = 48000;
      };
    };
  };
}
