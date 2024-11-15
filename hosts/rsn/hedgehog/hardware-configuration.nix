{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  environment.persistence."/persist" = {
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/libvirt"
      "/var/lib/nixos"

      "/var/log"
    ];
    files = [
      "/etc/machine-id"
      "/etc/wpa_supplicant.conf"
    ];
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
    # luks stuff
    "aes"
    "aesni_intel"
    "cryptd"
  ];

  boot.kernelModules = ["kvm-amd"];
  boot.kernel.sysctl = {
    "vm.swapiness" = 10;
  };

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
    zfsSupport = true;
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  boot.initrd.secrets = {
    "/crypt.keyfile" = "/persist/secrets/initrd/crypt.keyfile";
  };

  boot.initrd.luks.devices = {
    cryptboot = {
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_1000GB_23235A801926-part3";
      preLVM = true;
      allowDiscards = true;
      keyFile = "/crypt.keyfile";
    };
    cryptroot = {
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_1000GB_23235A801926-part4";
      preLVM = true;
      allowDiscards = true;
      keyFile = "/crypt.keyfile";
    };
    cryptswap = {
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_1000GB_23235A801926-part5";
      preLVM = true;
      allowDiscards = true;
      keyFile = "/crypt.keyfile";
    };
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
  '';

  fileSystems = {
    "/" = {
      device = "rpool/local/root";
      fsType = "zfs";
    };

    "/efi" = {
      device = "/dev/disk/by-uuid/9D28-C7C8";
      fsType = "vfat";
    };

    "/boot" = {
      device = "bpool/boot";
      fsType = "zfs";
    };

    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
    };

    "/home/risson" = {
      device = "rpool/persist/home/risson";
      fsType = "zfs";
    };

    "/root" = {
      device = "rpool/persist/home/root";
      fsType = "zfs";
    };

    "/persist" = {
      device = "rpool/persist/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/var/lib/docker" = {
      device = "rpool/persist/docker";
      fsType = "zfs";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/78ac3f8f-d64e-4997-8748-55f73ba64c08";}
  ];
}
