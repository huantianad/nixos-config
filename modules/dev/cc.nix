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
  cfg = config.modules.dev.cc;
in {
  options.modules.dev.cc = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      clang
      bear
      gdb
      cmake
      llvmPackages.libcxx
    ];
  };
}
