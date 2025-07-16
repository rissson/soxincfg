{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.kanshi = {
        enable = true;
        profiles = {
          bar-horse-default = {
            outputs = [
              {
                criteria = "DP-1";
                mode = "1920x1080@239.964Hz";
                position = "0,0";
              }
              {
                criteria = "HDMI-A-1";
                mode = "1920x1080@60Hz";
                position = "1920,0";
              }
              {
                criteria = "DP-3";
                mode = "1920x1080@60Hz";
                transform = "270";
                position = "3840,0";
              }
            ];
          };
        };
      };
    })
  ];
}
