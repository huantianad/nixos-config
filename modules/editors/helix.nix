{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.helix;
in
{
  options.modules.editors.helix = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.huantian.programs.helix = {
      enable = true;
      defaultEditor = true;

      extraPackages = [
        pkgs.nil
        pkgs.nixpkgs-fmt
      ];

      settings = {
        theme = "dracula";
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
        ];

        language-server.nil = {
          config = {
            formatting.command = [(lib.getExe pkgs.nixpkgs-fmt)];
            nix.flake.autoArchive = true;
          };
        };
      };
    };
  };
}
