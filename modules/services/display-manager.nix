{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      # services.getty = {
      #   autologinUser = "risson";
      #   autologinOnce = true;
      # };
      # environment.loginShellInit = ''
      #   [[ "$(tty)" == /dev/tty1 ]] && ${lib.getExe config.programs.uwsm.package} start -S -F /run/current-system/sw/bin/Hyprland
      # '';
      services.displayManager = {
        enable = true;
        sddm.enable = true;
        sddm.wayland.enable = true;

        # ly.enable = true;
        # ly.settings = {
        #   tty = 7;
        # };
      };
      services.libinput = {
        enable = true;
      };
    })

    # (lib.optionalAttrs (mode == "home-manager") {
    #   home.keyboard.options = ["grp:alt_caps_toggle" "caps:escape"];
    #
    #   xresources = {
    #     properties = {
    #       "*foreground" = "#b2b2b2";
    #       "*background" = "#020202";
    #     };
    #   };
    #
    #   services.random-background = {
    #     enable = false;
    #     enableXinerama = true;
    #     display = "center";
    #     imageDirectory = "%h/.background-images";
    #     interval = "1h";
    #   };
    # })
  ];
}
