{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof swaylock || loginctl lock-session";
            before_sleep_cmd = "loginctl lock-session";
          };

          listener = [
            {
              timeout = 60 * 15;
              command = "loginctl lock-session";
            }
          ];
        };
      };
    })
  ];
}
