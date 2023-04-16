{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      programs.fzf = {
        enable = true;
        defaultCommand = "${pkgs.fd}/bin/fd --type f";
      };
    })
  ];
}
