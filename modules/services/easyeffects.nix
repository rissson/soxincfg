{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      programs.dconf.enable = true;
    })

    (lib.optionalAttrs (mode == "home-manager") {
      services.easyeffects.enable = true;
    })
  ];
}
