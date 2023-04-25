{
  mode,
  pkgs,
  lib,
  ...
}: let
  devices = ["BAT0"];
  notifyCapacity = 10;
  hibernateCapacity = 5;

  script = pkgs.writeShellScriptBin "lowbatt" ''
    function notify() {
      ${pkgs.libnotify}/bin/notify-send \
        --urgency=critical \
        --hint=int:transient:1 \
        --icon=battery_empty \
        "$1" "$2"
    }

    for device in ${lib.concatStringsSep " " devices}; do
      battery_capacity=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/$device/capacity)
      battery_status=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/$device/status)

      if [[ $battery_status != "Discharging" ]]; then
        continue
      fi

      if [[ $battery_capacity -le ${toString notifyCapacity} ]]; then
        notify "Battery Low" "You should probably plug-in."
      fi

      if [[ $battery_capacity -le ${toString hibernateCapacity} ]]; then
        notify "Battery Critically Low" "Computer will hibernate in 60 seconds."

        sleep 60

        battery_status=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/$device/status)
        if [[ $battery_status = "Discharging" ]]; then
          systemctl hibernate
        fi
      fi
    done
  '';
in {
  config = lib.mkIf (pkgs.stdenv.isLinux) (lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      systemd.user.timers."lowbatt" = {
        Unit = {
          Description = "check battery level";
        };

        Timer = {
          OnBootSec = "1m";
          OnUnitInactiveSec = "1m";
          Unit = "lowbatt.service";
        };

        Install = {
          WantedBy = ["timers.target"];
        };
      };

      systemd.user.services."lowbatt" = {
        Unit = {
          Description = "battery level notifier";
        };

        Service = {
          PassEnvironment = "DISPLAY";
          ExecStart = "${script}/bin/lowbatt";
        };
      };
    })
  ]);
}
