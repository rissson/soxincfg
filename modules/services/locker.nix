{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.screen-locker = {
        enable = true;
        inactiveInterval = 10;
        lockCmd = "swaylock -f";
      };
    })
  ];
}
