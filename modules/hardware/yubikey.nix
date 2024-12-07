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

      services.pcscd.enable = true;

      security.pam.u2f = {
        enable = true;
        settings = {
          cue = true;
        };
      };
    })
  ];
}
