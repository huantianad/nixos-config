{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    configurationLimit = 5;
    efiSupport = true;
    device = "nodev";
  };

  boot.initrd.kernelModules = ["nvme"];
  fileSystems."/" = {
    device = "/dev/sda3";
    fsType = "xfs";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/61E0-20B8";
    fsType = "vfat";
  };
}
