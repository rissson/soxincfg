{
  mode,
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      soxin.programs.autorandr = {
        enable = pkgs.stdenv.isLinux;
      };
    }

    (lib.optionalAttrs (mode == "home-manager") {
      programs.autorandr = {
        hooks = {
          postswitch = {
            move-workspaces-to-main = ''
              set -euo pipefail

              # Make sure that i3 is running
              if [[ "$( ${pkgs.i3}/bin/i3-msg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.active == true) | .name' | wc -l )" -eq 1 ]]; then
                echo "no other monitor, bailing out"
                exit 0
              fi

              # Figure out the identifier of the main monitor
              readonly main_monitor="$( ${pkgs.i3}/bin/i3-msg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.active == true and .primary == true) | .name' )"

              # Get the list of workspaces that are not on the main monitor
              readonly workspaces=( $(${pkgs.i3}/bin/i3-msg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.output != "''${main_monitor}") | .name') )

              # Move all workspaces over
              for workspace in "''${workspaces[@]}"; do
                ${pkgs.i3}/bin/i3-msg "workspace ''${workspace}; move workspace to output ''${main_monitor}"
              done
            '';

            restart-polybar = ''
              set -euo pipefail

              systemctl --user restart polybar.service
            '';
          };
        };

        profiles = {
          hedgehog-default = {
            fingerprint = {
              eDP-1 = "00ffffffffffff0030aeba4000000000001b0104a5221378eacde5955b558f271d505400000001010101010101010101010101010101243680a070381f403020350058c210000019502b80a070381f403020350058c2100000190000000f00d10932d10930190a0030e4ba05000000fe004c503135365746392d53504b33002c";
            };

            config = {
              eDP-1 = {
                enable = true;
                primary = true;
                position = "0x0";
                mode = "1920x1080";
                gamma = "1.0:0.909:0.909";
                rate = "59.98";
              };
            };
          };
        };
      };
    })
  ];
}
