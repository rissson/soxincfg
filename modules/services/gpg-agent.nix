{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "Nixos") {
      programs.gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-all;

        enableSSHSupport = true;
        enableExtraSocket = true;
      };
    })

    (lib.optionalAttrs (mode == "home-manager") {
      services.gpg-agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-all;

        enableSshSupport = true;
        enableExtraSocket = true;

        defaultCacheTtl = 7200;
        maxCacheTtl = 7200;
        defaultCacheTtlSsh = 7200;
        maxCacheTtlSsh = 7200;
      };
    })
  ];
}
