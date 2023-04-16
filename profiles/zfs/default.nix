{
  mode,
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      boot = {
        kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
        kernelParams = ["elevator=none"];
        supportedFilesystems = ["zfs"];
        loader.grub.zfsSupport = true;
      };

      services.zfs = {
        autoScrub = {
          enable = true;
          interval = "weekly";
        };
        trim = {
          enable = true;
          interval = "weekly";
        };

        zed.settings = {
          ZED_EMAIL_ADDR = "root@lama-corp.space";
          ZED_EMAIL_PROG = "${pkgs.system-sendmail}/bin/sendmail";
          ZED_EMAIL_OPTS = "@ADDRESS@";
        };

        autoSnapshot = {
          enable = true;
          flags = "-k -p --utc -v";
          frequent = 8;
          hourly = 48;
          daily = 14;
          weekly = 8;
          monthly = 13;
        };
      };

      environment.systemPackages = with pkgs; [
        lzop
        mbuffer
      ];

      virtualisation.docker.storageDriver = "zfs";
    })
  ];
}
