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
    services.openssh.enable = true;

    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDULu9ey1UPD0z2DFD9NnZzPZkxsows/jD8UkWgzYZZpo3gMFCfMjdAHdMYBFx760uzSmgIQ9LYuw+pimnoSwOIdPyQpkVyK0AV0iCj5gpsm6dmsPTt0G/+rUdka2Wf5a876LSsU5FBo/Ei+d2cCPSOW8Nn9ZYH2ZtbiSE1BCx2nns+laFdOvOlV/Ff6jzg31nRsFFui/MlmhCyxy2grEeCJtlw9Ykg1OBLRETE2KEuqnOUbDwVPaL3ZAlV8SPQX6v5YYPY8ZLzVUyKWJF0BJrVKwMMzkarnt1tp9S+2SYSaszo5C4ljXAfanA7WcIYbg+8kKOcWymzUkE5/6AbPuAn ssh-key-2022-03-04"
    ];
    users.users.huantian.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDULu9ey1UPD0z2DFD9NnZzPZkxsows/jD8UkWgzYZZpo3gMFCfMjdAHdMYBFx760uzSmgIQ9LYuw+pimnoSwOIdPyQpkVyK0AV0iCj5gpsm6dmsPTt0G/+rUdka2Wf5a876LSsU5FBo/Ei+d2cCPSOW8Nn9ZYH2ZtbiSE1BCx2nns+laFdOvOlV/Ff6jzg31nRsFFui/MlmhCyxy2grEeCJtlw9Ykg1OBLRETE2KEuqnOUbDwVPaL3ZAlV8SPQX6v5YYPY8ZLzVUyKWJF0BJrVKwMMzkarnt1tp9S+2SYSaszo5C4ljXAfanA7WcIYbg+8kKOcWymzUkE5/6AbPuAn ssh-key-2022-03-04"
    ];
  };
}
