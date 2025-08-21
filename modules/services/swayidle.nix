{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.swayidle = {
        enable = true;
        events = [
          {
            event = "lock";
            command = "pidof swaylock || swaylock -f";
          }
          {
            event = "before-sleep";
            command = "loginctl lock-session";
          }
        ];
        timeouts = [
          {
            timeout = 60 * 5;
            command = "loginctl lock-session";
          }
          {
            timeout = 60 * 10;
            command = "swaymsg \"output * power off\"";
            resumeCommand = "swaymsg \"output * power on\"";
          }
        ];
      };
    })
  ];
}
