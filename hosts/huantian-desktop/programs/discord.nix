{ config, pkgs, lib, inputs, ... }:

{
  config = {
    nixpkgs.overlays = [ inputs.powercord-overlay.overlay ];

    environment.systemPackages = [
      (pkgs.discord-plugged.override {
        discord-canary = pkgs.discord-canary.override {
          nss = pkgs.nss_latest;
          withOpenASAR = true;
        };

        plugins = with inputs; [
          powercord-better-replies
          powercord-double-click-vc
          powercord-mute-new-guild
          powercord-no-double-back-pc
          powercord-remove-invite-from-user-context-menu
          powercord-screenshare-crack
          powercord-unindent
          powercord-vpc-shiki
        ];
      })
    ];
  };
}
