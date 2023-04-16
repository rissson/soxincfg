{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      services.printing = {
        enable = true;
        drivers = [
          pkgs.hplipWithPlugin
        ];
      };

      services.avahi = {
        enable = true;
        nssmdns = true;
        openFirewall = true;
      };
    })
  ];
}
