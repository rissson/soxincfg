{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      hardware.sane = {
        enable = true;
        brscan5.enable = true;
      };

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
