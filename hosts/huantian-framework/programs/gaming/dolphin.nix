{ config, pkgs, lib, inputs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      dolphin-emu-beta

      # BPS and IPS patching
      # flips
    ];

    # # GameCube controllers
    # services.udev.packages = [ pkgs.dolphinEmu ];

    # # DolphinBar
    # services.udev.extraRules = ''
    #   SUBSYSTEM=="hidraw", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", MODE="0666"
    # '';
  };
}
