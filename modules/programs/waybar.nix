{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      programs.waybar = {
        enable = true;

        systemd.enable = true;

        settings = [
          {
            layer = "top";
            position = "top";
            # height = 21;
            modules-left = [
              "sway/workspaces"
              "sway/mode"
              "sway/scratchpad"
              "sway/window"
            ];
            modules-right = [
              "custom/disk"
              "cpu"
              "memory"
              "backlight"
              "pulseaudio"
              "battery"
              "network"
              "clock"
              "clock#utc"
              "idle_inhibitor"
              "tray"
            ];

            "custom/disk" = {
              format = "Disk: {}";
              interval = 60;
              exec = "df -h --output=avail / | tail -1 | tr -d ' '";
            };

            cpu = {
              interval = 1;
              format = "CPU: {usage}%";
            };

            memory = {
              format = "Mem: {}%";
            };

            backlight = {
              format = "{icon} {percent}%";
              format-icons = ["🔅" "🔆"];
            };

            pulseaudio = {
              scroll-step = 5;

              format = "{icon} {volume}% {format_source}";
              format-muted = "🔇 {format_source}";
              format-bluetooth = "{icon} {volume}% {format_source}";
              format-bluetooth-muted = "{icon} {volume}% {format_source}";

              format-source = " {volume}%";
              format-source-muted = "";

              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = ["🔈" "🔉" "🔊"];
              };

              on-click = "uwsm app -- ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              on-click-right = "uwsm app -- ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            };

            battery = {
              full-at = 97;
              states = {
                warning = 20;
                critical = 10;
              };
              format = "{icon} {capacity}%";
              format-charging = "⚡ {capacity}%";
              format-icons = ["" "" "" "" ""];
            };

            network = {
              family = "ipv4";
              format-wifi = " ({signalStrength}%) {essid}";
              format-ethernet = "{ipaddr}/{cidr}";
              format-linked = "{ifname} (No IP)";
              format-disconnected = "Disconnected ⚠";
              tooltip-format = "{ifname} via {gwaddr}";
            };

            #
            clock = {
              interval = 1;
              format = "{:%a %Y-%m-%d %H:%M:%S}";
              tooltip-format = "{calendar}";
            };

            "clock#utc" = {
              interval = 1;
              format = "{:%H:%M:%S}";
              timezone = "UTC";
              tooltip-format = "{calendar}";
            };

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "";
                deactivated = "";
              };
              on-click-right = "loginctl lock-session";
            };
            tray = {
              spacing = 10;
            };
          }
        ];

        style = ''
          * {
            font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
            font-size: 12px;
            margin: 0;
            padding: 0;
            border: none;
            border-radius: 0;
            box-shadow: none;
            text-shadow: none;
          }

          window#waybar {
            background-color: rgba(43, 44, 52, 0.8);
            color: #ffffff;
            transition: background-color 0.5s;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

          #window {
            font-family: 'Sarasa Gothic SC', sans-serif;
          }

          #clock,
          #clock-utc {
            background: #3b3f51;
            color: #ffffff;
            padding: 0px 8px;
            border-radius: 4px;
          }

          #battery,
          #cpu,
          #custom-disk
          #memory,
          #backlight,
          #network,
          #pulseaudio,
          #tray,
          #mode,
          #idle_inhibitor,
          #keyboard-state,
          #scratchpad {
            padding: 0px 8px;
            background-color: #3b3f51;
            color: #ffffff;
          }

          #battery.charging{
            background-color: #b5b4e2;
          }

          #battery.critical:not(.charging) {
            background-color: #b54f4f;
            animation: blink 0.5s linear infinite alternate;
          }

          @keyframes blink {
            to {
              background-color: #ffffff;
              color: #3b3f51;
            }
          }

          #network.disconnected {
            background-color: #b54f4f;
          }

          #pulseaudio.muted {
            background-color: #3b3f51;
            color: #b5b4e2;
          }

          #tray {
            background-color: #b5b4e2;
            color: #282a36;
          }

          #tray>.passive {
            -gtk-icon-effect: dim;
            color: #6272a4;
          }

          #tray>.needs-attention {
            background-color: #ff5555;
            color: #ffffff;
          }

          #idle_inhibitor.activated {
            background-color: #b5b4e2;
            color: #3b3f51;
          }

          #workspaces button,
          #mode {
            padding: 0px 8px;
            background-color: transparent;
            color: #ffffff;
          }

          #workspaces button:hover,
          #workspaces button.focused {
            background-color: #6272a4;
            box-shadow: inset 0 -3px #ffffff;
          }

          #workspaces button.urgent {
            background-color: #b54f4f;
          }

          label:focus {
            background-color: #000000;
          }
        '';
      };
    })
  ];
}
