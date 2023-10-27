{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      services.openssh = {
        enable = true;
        settings = {
          X11Forwarding = true;
          PasswordAuthentication = false;
          StreamLocalBindUnlink = true;
        };
      };
    })
  ];
}
