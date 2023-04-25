{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.screen-locker = {
        enable = pkgs.stdenv.isLinux;
        inactiveInterval = 15;
        lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color --color=ffa500 --clock --show-failed-attempts --bar-indicator --date-str='%A %Y-%m-%d -i $(${pkgs.coreutils}/bin/shuf -n1 -e /home/risson/.lock-images/*.jpg)";
      };
    })
  ];
}
