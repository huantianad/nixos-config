{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "virtio_scsi" "usbhid"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/mapper/ocivolume-root";
    fsType = "xfs";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/4071-E886";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
