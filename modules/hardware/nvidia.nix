{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.nvidia;
in
{
  options.modules.hardware.nvidia = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    environment.variables.MOZ_DISABLE_RDD_SANDBOX = "1";
    environment.variables.LIBVA_DRIVER_NAME = "nvidia";

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        (nvidia-vaapi-driver.overrideAttrs (attrs: {
          version = "0.0.9";
          src = fetchFromGitHub {
            owner = "elFarto";
            repo = attrs.pname;
            rev = "v0.0.9";
            sha256 = "sha256-mQtprgm6QonYiMUPPIcCbWxPQ/b2XuQiOkROZNPYaQk=";
          };
          buildInputs = attrs.buildInputs ++ [
            pkgs.libdrm
          ];
        }))
      ];
    };
  };
}
