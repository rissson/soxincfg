{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      environment.systemPackages = with pkgs; [
        yubico-piv-tool
        yubikey-manager
        yubikey-personalization
        yubikey-personalization-gui
      ];

      hardware.gpgSmartcards.enable = true;

      services.pcscd.enable = true;
      services.udev.packages = [pkgs.yubikey-personalization];

      security.pam.u2f = {
        enable = true;
        settings = {
          cue = true;
        };
      };
    })
  ];
}
