{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      services.xserver = {
        enable = true;
        autorun = true;
        autoRepeatDelay = 200;
        autoRepeatInterval = 30;

        # TODO: move this to keyboard
        xkbOptions = lib.concatStringsSep "," [
          "grp:alt_caps_toggle"
          "caps:swapescape"
        ];

        libinput = {
          enable = true;
        };

        displayManager = {
          defaultSession = "none+i3";
          autoLogin = {
            enable = true;
            user = "risson";
          };
          lightdm = {
            enable = true;
          };
        };

        videoDrivers = lib.mkDefault [
          "radeon"
          "cirrus"
          "vesa"
          "vmware"
          "modesetting"
          "intel"
        ];

        windowManager = {
          i3.enable = true;
        };
      };
    })

    (lib.optionalAttrs (mode == "home-manager") {
      home.keyboard.options = ["grp:alt_caps_toggle" "caps:swapescape"];

      xresources = {
        properties = {
          "*foreground" = "#b2b2b2";
          "*background" = "#020202";
        };
      };

      services.random-background = {
        enable = pkgs.stdenv.isLinux;
        enableXinerama = true;
        display = "center";
        imageDirectory = "%h/.background-images";
        interval = "1h";
      };
    })
  ];
}
