{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      programs.gpg = {
        enable = true;
        settings = {
          throw-keyids = true;
          keyserver = "hkps://keys.openpgp.org";
        };
      };
    })
  ];
}
