{
  mode,
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      xsession = {
        enable = pkgs.stdenv.isLinux;

        windowManager = {
          i3 = import ./i3-config.lib.nix {inherit pkgs lib;};
        };

        initExtra = ''
          exec &> ~/.xsession-errors

          # fix the look of Java applications
          export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
        '';
      };
    })
  ];
}
