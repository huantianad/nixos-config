{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;

    # this should be part of kde config
    # environment.systemPackages = mkIf config.modules.desktop.kde.enable [
    #   pkgs.kdePackages.bluedevil # Bluetooth config
    #   pkgs.kdePackages.bluez-qt
    # ];
  };
}
