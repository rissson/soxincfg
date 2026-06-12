{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.boot.loader.systemd-boot;

  efi = config.boot.loader.efi;

  checkedSource = pkgs.runCommand "systemd-boot" {preferLocalBuild = true;} ''
    install -m755 ${./boot-install.py} $out
    ${lib.getExe pkgs.buildPackages.mypy} \
      --no-implicit-optional \
      --disallow-untyped-calls \
      --disallow-untyped-defs \
      $out
  '';

  systemdBootBuilder = pkgs.replaceVarsWith {
    name = "systemd-boot";
    dir = "bin";
    src = checkedSource;
    isExecutable = true;

    replacements = rec {
      inherit (builtins) storeDir;
      inherit (pkgs) python3;

      systemd = config.systemd.package;
      bootspecTools = config.boot.bootspec.package;
      nix = config.nix.package.out;

      sbctl = lib.getExe pkgs.sbctl;
      ukify = "${pkgs.systemdUkify}/bin/ukify";
      stub = "${systemd}/lib/systemd/boot/efi/linux${pkgs.stdenv.hostPlatform.efiArch}.efi.stub";

      timeout =
        if config.boot.loader.timeout == null
        then "menu-force"
        else config.boot.loader.timeout;

      configurationLimit =
        if cfg.configurationLimit == null
        then 0
        else cfg.configurationLimit;

      inherit (cfg) consoleMode graceful editor rebootForBitlocker;

      inherit (efi) efiSysMountPoint canTouchEfiVariables;

      bootMountPoint =
        if cfg.xbootldrMountPoint != null
        then cfg.xbootldrMountPoint
        else efi.efiSysMountPoint;

      nixosDir = "/EFI/nixos";

      inherit (config.system.nixos) distroName;

      checkMountpoints = pkgs.writeShellScript "check-mountpoints" ''
        fail() {
          echo "$1 = '$2' is not a mounted partition. Is the path configured correctly?" >&2
          exit 1
        }
        ${pkgs.util-linuxMinimal}/bin/findmnt ${efiSysMountPoint} > /dev/null || fail efiSysMountPoint ${efiSysMountPoint}
        ${
          lib.optionalString (cfg.xbootldrMountPoint != null)
          "${pkgs.util-linuxMinimal}/bin/findmnt ${cfg.xbootldrMountPoint} > /dev/null || fail xbootldrMountPoint ${cfg.xbootldrMountPoint}"
        }
      '';

      copyExtraFiles = pkgs.writeShellScript "copy-extra-files" ''
        ${concatStrings (
          mapAttrsToList (n: v: ''
            ${pkgs.coreutils}/bin/install -Dp "${v}" "${bootMountPoint}/"${escapeShellArg n}
            ${pkgs.coreutils}/bin/install -D /dev/null "${bootMountPoint}/${nixosDir}/.extra-files/"${escapeShellArg n}
          '')
          cfg.extraFiles
        )}

        ${concatStrings (
          mapAttrsToList (n: v: ''
            ${pkgs.coreutils}/bin/install -Dp "${pkgs.writeText n v}" "${bootMountPoint}/loader/entries/"${escapeShellArg n}
            ${pkgs.coreutils}/bin/install -D /dev/null "${bootMountPoint}/${nixosDir}/.extra-files/loader/entries/"${escapeShellArg n}
          '')
          cfg.extraEntries
        )}
      '';
    };
  };

  finalSystemdBootBuilder = pkgs.writeScript "install-systemd-boot.sh" ''
    #!${pkgs.runtimeShell}
    set -euo pipefail
    ${systemdBootBuilder}/bin/systemd-boot "$@"
    ${cfg.extraInstallCommands}
  '';
in {
  system.build.installBootLoader = lib.mkForce finalSystemdBootBuilder;
}
