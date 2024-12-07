{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      hardware.rtl-sdr.enable = true;

      environment.systemPackages = with pkgs; [
        libusb1
        rtl-sdr

        gqrx
      ];
    })
  ];
}
