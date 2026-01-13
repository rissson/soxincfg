{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      virtualisation.libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
      virtualisation.spiceUSBRedirection.enable = true;

      soxincfg.users.groups = ["libvirtd"];
    })
  ];
}
