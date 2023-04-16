{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      virtualisation.docker = {
        enable = true;
      };

      soxincfg.users.groups = ["docker"];
    })
  ];
}
