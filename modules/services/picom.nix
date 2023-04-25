{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.picom = {
        enable = pkgs.stdenv.isLinux;
        fade = true;
        fadeDelta = 2;
        opacityRules = [
          "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
        ];
      };
    })
  ];
}
