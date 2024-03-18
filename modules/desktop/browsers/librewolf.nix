{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.librewolf;
in
{
  options.modules.desktop.browsers.librewolf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      let
        withPlasma = pkgs.librewolf.override { nativeMessagingHosts = [ pkgs.kdePackages.plasma-browser-integration ]; };
      in
      [ withPlasma ];

    home-manager.users.huantian.home.file = {
      ".librewolf/librewolf.overrides.cfg".text = ''
        defaultPref("webgl.dxgl.enabled", true);
        defaultPref("webgl.disabled", false);

        defaultPref("webgl.enable-webgl2", true);
        defaultPref("webgl.min_capability_mode", false);
        defaultPref("webgl.disable-extensions", false);
        defaultPref("webgl.disable-fail-if-major-performance-caveat", true);
        defaultPref("webgl.enable-debug-renderer-info", true);

        defaultPref("pdfjs.enableWebGL", true);

        defaultPref("dom.event.clipboardevents.enabled", true);

        defaultPref("dom.webaudio.enabled", true);

        defaultPref("identity.fxaccounts.enabled", true);
        defaultPref("services.sync.engine.passwords", false);
      '';
    };
  };
}
