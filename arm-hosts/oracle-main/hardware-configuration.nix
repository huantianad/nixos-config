{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    configurationLimit = 5;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/" = { device = "/dev/mapper/ocivolume-root"; fsType = "xfs"; };
  fileSystems."/boot/efi" = { device = "/dev/disk/by-uuid/4071-E886"; fsType = "vfat"; };
}
