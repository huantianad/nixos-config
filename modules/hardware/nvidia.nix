{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.nvidia;
in
{
  options.modules.hardware.nvidia = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    environment.systemPackages = with pkgs; [
      # Respect XDG conventions, damn it!
      (writeScriptBin "nvidia-settings" ''
        #!${stdenv.shell}
        mkdir -p "$XDG_CONFIG_HOME/nvidia"
        exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
      '')
    ];
  };
}