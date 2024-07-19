{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.usbmuxd;
in {
  options.modules.services.usbmuxd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.usbmuxd.enable = true;

    environment.systemPackages = with pkgs; [
      libimobiledevice
    ];
  };
}
