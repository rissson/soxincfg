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
        forwardX11 = true;
        passwordAuthentication = false;
        extraConfig = ''
          StreamLocalBindUnlink yes
        '';
      };
    })
  ];
}
