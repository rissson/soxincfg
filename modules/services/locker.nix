{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.screen-locker = {
        enable = true;
        inactiveInterval = 10;
        lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color --color=000000 --clock --show-failed-attempts --bar-indicator";
        # lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color --color=ffa500 --clock --show-failed-attempts --bar-indicator -i $(${pkgs.coreutils}/bin/shuf -n1 -e /home/risson/.lock-images/*.jpg)";
      };
    })
  ];
}
