{
  mode,
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      soxin.programs.starship = {
        enable = true;
      };
    }

    (lib.optionalAttrs (mode == "home-manager") {
      programs.starship = {
        settings = {
          add_newline = false;
          kubernetes = {
            disabled = false;
          };
        };
      };
    })
  ];
}
