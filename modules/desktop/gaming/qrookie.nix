{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.qrookie;
in
{
  options.modules.desktop.gaming.qrookie = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      inputs.glaumar.packages.${pkgs.system}.qrookie
    ];

    programs.adb.enable = true;
    users.users.huantian.extraGroups = [ "adbusers" ];
  };
}
