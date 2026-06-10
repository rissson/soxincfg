{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      virtualisation.docker = {
        enable = true;
        daemon = {
          settings = {
            live-restore = true;
          };
        };
      };

      soxincfg.users.groups = ["docker"];
    })
  ];
}
