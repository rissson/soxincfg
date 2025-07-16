{
  mode,
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      security.pam.services.swaylock = {};
    })

    (lib.optionalAttrs (mode == "home-manager") {
      programs.swaylock = {
        enable = true;

        settings = {
          color = "000000";
        };
      };
    })
  ];
}
