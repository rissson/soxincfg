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

      services.udev.extraRules = ''
        ATTRS{idVendor}=="04f9", ATTRS{idProduct}=="0459", MODE="0664", GROUP="scanner", ENV{libsane_matched}="yes"
      '';

      services.printing = {
        enable = true;
        drivers = [
          pkgs.hplipWithPlugin
        ];
      };

      services.avahi = {
        enable = true;
        nssmdns4 = true;
        nssmdns6 = true;
        openFirewall = true;
      };
    })
  ];
}
