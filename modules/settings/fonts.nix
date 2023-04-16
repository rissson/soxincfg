{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS" || mode == "darwin") {
      fonts = {
        fontDir.enable = true;

        fonts = with pkgs; [
          powerline-fonts
          twemoji-color-font

          (nerdfonts.override {fonts = ["FiraCode"];})

          noto-fonts
          noto-fonts-extra
          noto-fonts-emoji
          noto-fonts-cjk

          symbola
          vegur
          b612
        ];
      };
    })

    (lib.optionalAttrs (mode == "NixOS") {
      fonts = {
        enableDefaultFonts = true;
        enableGhostscriptFonts = true;

        fontconfig.defaultFonts = {
          monospace = [
            "FiraCode Nerd Font Mono"
            "DejaVu Sans Mono"
          ];
        };
      };
    })

    {
      fonts.fontconfig.enable = true;
    }
  ];
}
