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

        packages = with pkgs; [
          powerline-fonts
          twemoji-color-font

          nerd-fonts.fira-code

          noto-fonts
          noto-fonts-extra
          noto-fonts-emoji
          noto-fonts-cjk-sans

          symbola
          vegur
          b612

          liberation_ttf
          vistafonts
          wine64Packages.fonts
        ];
      };
    })

    (lib.optionalAttrs (mode == "NixOS") {
      fonts = {
        enableDefaultPackages = true;
        enableGhostscriptFonts = true;

        fontconfig.allowType1 = true;
        fontconfig.allowBitmaps = true;
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
