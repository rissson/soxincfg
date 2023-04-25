{
  mode,
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      programs.dconf.enable = true;
    })

    (lib.optionalAttrs (mode == "home-manager") {
      gtk = {
        enable = true;
        font = {
          package = pkgs.hack-font;
          name = "xft:SourceCodePro:style:Regular:size=9:antialias=true";
        };
        iconTheme = lib.mkIf pkgs.stdenv.isLinux {
          package = pkgs.arc-icon-theme;
          name = "Arc";
        };
        theme = lib.mkIf pkgs.stdenv.isLinux {
          package = pkgs.arc-theme;
          name = "Arc-dark";
        };
      };
    })
  ];
}
