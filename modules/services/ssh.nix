{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in
{
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    users.users.huantian.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdHdFlnoznfUXyvZ5m79WkI5xGQMO1U7M8N6t6KrBA3 huantian@huantian-desktop"
    ];
  };
}
