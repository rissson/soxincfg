{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      services.udev.extraRules = ''
        # ZSA keyboard
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
        # ZSA Moonlander
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
      '';
    })
  ];
}
