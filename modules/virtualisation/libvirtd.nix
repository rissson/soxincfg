{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      virtualisation.libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
        qemu.ovmf.packages = [
          pkgs.OVMF.fd
          pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
        ];
      };
      virtualisation.spiceUSBRedirection.enable = true;

      soxincfg.users.groups = ["libvirtd"];
    })
  ];
}
