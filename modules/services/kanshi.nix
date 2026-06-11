{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.kanshi = {
        enable = true;
        settings = [
          {
            profile = {
              name = "bar-panda-default";
              outputs = [
                {
                  criteria = "DP-1";
                  mode = "1920x1080@239.964Hz";
                  position = "0,0";
                }
                {
                  criteria = "DP-3";
                  mode = "3440x1440@174.963Hz";
                  position = "1920,0";
                }
                {
                  criteria = "DP-2";
                  mode = "1920x1080@60Hz";
                  position = "5360,0";
                  transform = "270";
                }
              ];
            };
          }
          {
            profile = {
              name = "bar-horse-default";
              outputs = [
                {
                  criteria = "DP-1";
                  mode = "1920x1080@60Hz";
                  position = "0,0";
                }
                {
                  criteria = "HDMI-A-1";
                  mode = "1920x1080@60Hz";
                  position = "1920,0";
                }
                {
                  criteria = "DVI-D-1";
                  mode = "1920x1080@60Hz";
                  position = "3840,0";
                  transform = "270";
                }
              ];
            };
          }
        ];
      };
    })
  ];
}
