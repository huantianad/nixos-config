{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.disko
  ];

  services.fstrim.enable = true;

  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  disko.devices = {
    disk = {
      main-disk = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            efi = {
              type = "EF00";
              size = "2G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "300G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
