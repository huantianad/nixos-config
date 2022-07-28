{ config, pkgs, lib, inputs, ... }:

{
  config = {
    nixpkgs.overlays = [ inputs.powercord-overlay.overlay ];

    environment.systemPackages = [
      (pkgs.discord-plugged.override {
        # withOpenASAR = true;
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
