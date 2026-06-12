{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    # inputs.lanzaboote.nixosModules.lanzaboote
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
      "/etc/zfs/zpool.cache"
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

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    editor = false;
    sortKey = "nixos";
    edk2-uefi-shell = {
      enable = true;
      sortKey = "z_edk2-uefi-shell";
    };
    memtest86 = {
      enable = true;
      sortKey = "x_memtest";
    };
    netbootxyz = {
      enable = true;
      sortKey = "y_netbootxyz";
    };
    windows = {
      "10" = {
        title = "Windows 10";
        efiDeviceHandle = "HD0b";
        sortKey = "a_windows_10";
      };
    };
  };

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S7HDNS0L310718F-part2";
      preLVM = true;
      allowDiscards = true;
      bypassWorkqueues = true;
    };
  };

  boot.initrd.systemd.services.rollback = {
    description = "Rollback root filesystem to a blank state on boot";
    wantedBy = ["initrd.target"];
    after = ["zfs-import-rpool.service"];
    before = ["sysroot.mount"];
    unitConfig = {
      DefaultDependencies = "no";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${config.boot.zfs.package}/sbin/zfs rollback -r rpool/local/root@blank";
    };
  };

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

    "/var/log" = {
      device = "rpool/local/var/log";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7680-42AD";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };
}
