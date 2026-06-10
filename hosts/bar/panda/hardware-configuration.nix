{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
    powertop.enable = lib.mkForce false;
  };

  environment.persistence."/persist" = {
    files = [
      "/etc/machine-id"
    ];
  };

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "thunderbolt"
    "usb_storage"
    "usbhid"
    "sd_mod"
    # luks stuff
    "aes"
    "aesni_intel"
    "cryptd"
  ];

  boot.kernelModules = ["kvm-amd"];

  boot.loader.timeout = 60;
  boot.loader.systemd-boot = {
    enable = lib.mkForce false;
  };
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 8;
    measuredBoot = {
      enable = true;
      pcrs = [
        0
        4
        7
      ];
    };
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S7HDNS0L310718F-part2";
      preLVM = true;
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   zfs rollback -r rpool/local/root@blank
  # '';

  fileSystems = {
    "/" = {
      device = "rpool/local/root";
      fsType = "zfs";
      options = ["zfsutil"];
      neededForBoot = true;
    };

    "/nix" = {
      device = "rpool/local/nix";
      fsType = "zfs";
      options = ["zfsutil"];
      neededForBoot = true;
    };

    "/persist" = {
      device = "rpool/persist/persist";
      fsType = "zfs";
      options = ["zfsutil"];
      neededForBoot = true;
    };

    "/root" = {
      device = "rpool/persist/home/root";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/home/risson" = {
      device = "rpool/persist/home/risson";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/etc/nixos" = {
      device = "rpool/local/etc/nixos";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/var/lib/docker" = {
      device = "rpool/local/var/lib/docker";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/var/lib/nixos" = {
      device = "rpool/local/var/lib/nixos";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/var/lib/libvirt" = {
      device = "rpool/local/var/lib/libvirt";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/var/lib/systemd" = {
      device = "rpool/local/var/lib/systemd";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/var/lib/sbctl" = {
      device = "rpool/local/var/lib/sbctl";
      fsType = "zfs";
      options = ["zfsutil"];
    };
    "/var/lib/pcrlock.d" = {
      device = "rpool/local/var/lib/pcrlock.d";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/var/logs" = {
      device = "rpool/local/var/logs";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7680-42AD";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };
}
