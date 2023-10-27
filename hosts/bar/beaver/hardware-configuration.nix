{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
    powertop.enable = lib.mkForce false;
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sdhci_pci"
  ];

  boot.kernelModules = ["kvm-intel"];
  boot.kernel.sysctl = {
    "vm.swapiness" = 10;
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/29fac20e-2263-4c4d-af1f-139e73648537";
      fsType = "ext4";
    };
    "/efi" = {
      device = "/dev/disk/by-uuid/04D4-D315";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/37e2ed7e-0ac6-4aa6-8804-b822e41ae34d";}
  ];
}
