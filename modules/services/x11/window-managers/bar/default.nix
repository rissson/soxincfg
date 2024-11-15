{
  mode,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = {
    location = "top";
    dpi = null;
    height = 21;
    modules = {
      volume = {
        enable = true;
        order = 20;
      };
      network = {
        enable = true;
        order = 30;
        eth = ["eno1" "enp4s0" "enp5s0" "enp6s0" "enp0s20f0u2u2" "enp0s20f0u1u1" "enp193s0f3u1"];
        wlan = ["wlp1s0" "wlp4s0"];
      };
      cpu = {
        enable = true;
        order = 50;
      };
      ram = {
        enable = true;
        order = 60;
      };
      backlight = {
        enable = true;
        order = 80;
      };
      battery = {
        enable = true;
        order = 90;
        devices = [
          {
            device = "BAT1";
            fullAt = 97;
          }
        ];
      };
      time = {
        enable = true;
        order = 100;
        timezones = [
          {
            timezone = "Europe/Paris";
            prefix = "FR";
            format = "%a %Y-%m-%d %H:%M:%S";
          }
          {
            timezone = "UTC";
            prefix = "UTC";
            format = "%H:%M:%S";
          }
        ];
      };
      keyboardLayout = {
        enable = true;
        order = 110;
      };
    };
  };
in {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.polybar =
        lib.recursiveUpdate
        (import ./polybar.lib.nix {
          inherit pkgs lib;
          config = cfg;
        })
        {enable = true;};
    })
  ];
}
