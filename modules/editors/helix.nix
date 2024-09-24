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
  cfg = config.modules.editors.helix;
in {
  options.modules.editors.helix = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.variables.EDITOR = "helix";
    home-manager.users.huantian.programs.helix = {
      enable = true;

      extraPackages = let
        clipboard-tool =
          if config.modules.desktop.wayland.enable
          then pkgs.wl-clipboard
          else pkgs.xclip;
      in [
        clipboard-tool
        pkgs.nil
        pkgs.nixfmt-rfc-style
        pkgs.alejandra
        pkgs.nimlangserver
        pkgs.nph
      ];

      settings = {
        theme = "dracula";
        editor.soft-wrap.enable = true;
      };

      languages = {
        language = [
          {
            name = "haskell";
            auto-format = true;
          }
          {
            name = "nix";
            auto-format = true;
          }
          {
            name = "nim";
            auto-format = true;
            formatter = {
              command = "nph";
              args = ["-"];
            };
          }
        ];

        language-server.nil.config = {
          formatting.command = ["alejandra"];
          nix.flake.autoArchive = true;
        };

        language-server.rust-analyzer.config = {
          check.command = "clippy";
        };
      };
    };
  };
}
