{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      environment.systemPackages = with pkgs; [
        nitrokey-app2
        pynitrokey
      ];

      hardware.gpgSmartcards.enable = true;

      services.pcscd.enable = true;
      hardware.nitrokey.enable = true;

      security.pam.u2f = {
        enable = true;
        settings = {
          cue = true;
        };
      };
    })
  ];
}
