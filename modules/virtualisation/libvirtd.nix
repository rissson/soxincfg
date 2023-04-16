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

      soxincfg.users.groups = ["libvirtd"];
    })
  ];
}
