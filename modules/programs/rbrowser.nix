{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      soxin.programs.rbrowser = {
        enable = true;
        browsers = {
          "firefox@personal" = {};
          "firefox@authentik" = {};
          "chromium@default" = {};
        };
        setMimeList = true;
      };
    }

    (lib.optionalAttrs (mode == "home-manager") {
      home.file = {
        ## TODO: use options in home-manager and make a soxin module
        ".mozilla/firefox/profiles/personal/.keep".text = "";
        ".mozilla/firefox/profiles/authentik/.keep".text = "";
        ".mozilla/firefox/profiles.ini".text = ''
          [General]
          StartWithLastProfile=1

          [Profile0]
          Name=personal
          IsRelative=1
          Path=profiles/personal
          Default=1

          [Profile1]
          Name=profiles/authentik
          IsRelative=1
          Path=epita
        '';
      };
    })
  ];
}
