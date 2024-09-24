{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.librewolf;
in {
  options.modules.desktop.browsers.librewolf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = let
      withPlasma = pkgs.librewolf.override {
        nativeMessagingHosts =
          lib.optional config.modules.desktop.kde.enable pkgs.kdePackages.plasma-browser-integration;
      };
    in [withPlasma];

    home-manager.users.huantian.home.file = {
      ".librewolf/librewolf.overrides.cfg".text = ''
        defaultPref("dom.event.clipboardevents.enabled", true);

        // defaultPref("dom.webaudio.enabled", true);

        defaultPref("identity.fxaccounts.enabled", true);
        defaultPref("services.sync.engine.passwords", false);
      '';
    };
  };
}
