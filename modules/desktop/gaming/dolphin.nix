{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.gaming.dolphin;
in {
  options.modules.desktop.gaming.dolphin = {
    enable = mkBoolOpt false;
    setUdevRules = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      dolphin-emu-beta

      # BPS and IPS patching
      # flips
    ];

    # GameCube controllers
    services.udev.packages = mkIf cfg.setUdevRules [pkgs.dolphinEmu];

    # DolphinBar
    services.udev.extraRules = mkIf cfg.setUdevRules ''
      SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", MODE="0666"
    '';
  };
}
