{
  mode,
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      sound.enable = true;

      hardware = {
        pulseaudio = {
          enable = true;
          package = lib.mkIf config.soxin.hardware.bluetooth.enable pkgs.pulseaudioFull;
          systemWide = true;
          zeroconf.discovery.enable = true;
        };
      };

      environment.systemPackages = with pkgs; [
        pavucontrol
        pa_applet
      ];

      users.groups.pulse-access = {};
    })
  ];
}
