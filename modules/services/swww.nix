{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      services.swww = {
        enable = true;
      };

      systemd.user.services.random-background = {
        Unit = {
          Description = "Set random desktop background using feh";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
        };

        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "random-background.sh" ''
            RESIZE_TYPE="fit"
            export SWWW_TRANSITION_FPS=60
            export SWWW_TRANSITION_STEP=2

            find "$HOME/.background-images" -type f \
            | while read -r img; do
              echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
            done \
            | sort -u | cut -d':' -f2- \
            | while read -r img; do
                for d in $(swww query | grep -Po "^[^:]+"); do
                  [ -z "$img" ] && if read -r img; then true; else break 2; fi
                  swww img --resize "$RESIZE_TYPE" --outputs "$d" "$img"
                  unset -v img
                done
              done
          '';
          IOSchedulingClass = "idle";
        };

        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };
    })
  ];
}
