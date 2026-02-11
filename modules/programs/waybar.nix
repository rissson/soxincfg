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
              "backlight"
              "pulseaudio"
              "network"
              "battery"
              "clock"
              "clock#utc"
              "tray"
            ];

            backlight = {
              format = "<span color=\"#fbf1c7\">{icon}</span> {percent}%";
              format-icons = ["" "" "" "" "" "" "" "" ""];
              on-scroll-up = "brightnessctl s 1%+";
              on-scroll-down = "brightnessctl s 1%-";
              tooltip-format = "{percent}% screen brightness";
            };

            pulseaudio = {
              scroll-step = 5;

              format = "<span color=\"#fbf1c7\">{icon}</span>  {volume}% | {format_source}";
              format-bluetooth = "<span color=\"#fbf1c7\"></span> {volume}% | {format_source}";
              format-bluetooth-muted = "<span color=\"#fb4934\">󰝟 </span> | {format_source}";
              format-muted = "<span color=\"#fb4934\">󰝟</span> | {format_source}";
              format-source = "<span color=\"#fbf1c7\"></span> {volume}%";
              format-source-muted = "<span color=\"#fb4934\"></span>";
              format-icons = {
                headphone = "";
                hands-free = "󱠰";
                headset = "󰋎";
                phone = "";
                portable = "";
                car = "";
                default = ["" "" ""];
              };

              on-click = "uwsm app -- ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              on-click-right = "uwsm app -- ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            };

            network = {
              family = "ipv4";
              format = "{ifname}";
              format-wifi = "<span color=\"#fbf1c7\"></span>  {essid}";
              format-ethernet = "<span color=\"#fbf1c7\">󰈀</span>  {ipaddr}/{cidr}";
              format-disconnected = "<span color=\"#fbf1c7\">󱛅</span>  Disconnected";
              tooltip-format = "<span color=\"#fbf1c7\">󰛳</span>  {ifname} via {gwaddr}";
              tooltip-format-wifi = "<span color=\"#fbf1c7\"></span>  {essid} ({signalStrength}%) \r   {ipaddr}/{cidr} ({ifname} via {gwaddr})";
              tooltip-format-ethernet = "<span color=\"#fbf1c7\"></span>  {ifname}";
              tooltip-format-disconnected = "Disconnected";
              max-length = 50;
            };

            battery = {
              full-at = 97;
              states = {
                warning = 20;
                critical = 10;
              };
              format = "<span color=\"#fbf1c7\">{icon}</span> {capacity}%";
              format-charging = "<span color=\"#fbf1c7\">󰢝</span> {capacity}%";
              format-plugged = "<span color=\"#fbf1c7\"></span> {capacity}%";
              format-icons = ["" "" "" "" ""];
            };

            #
            clock = {
              interval = 1;
              format = "{:%a %Y-%m-%d %H:%M:%S}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              calendar = {
                mode = "month";
                mode-mon-col = 3;
                weeks-pos = "right";
                on-scroll = 1;
                on-click-right = "mode";
                format = {
                  months = "<span color='#ffead3'><b>{}</b></span>";
                  days = "<span color='#ebdbb2'><b>{}</b></span>";
                  weeks = "<span color='#83a598'><b>W{}</b></span>";
                  weekdays = "<span color='#fabd2f'><b>{}</b></span>";
                  today = "<span color='#d3869b'><b><u>{}</u></b></span>";
                };
              };
              actions = {
                on-click-right = "mode";
                on-scroll-up = "shift_up";
                on-scroll-down = "shift_down";
              };
            };

            "clock#utc" = {
              interval = 1;
              format = "{:%H:%M:%S}";
              timezone = "UTC";
              tooltip-format = "{calendar}";
            };

            tray = {
              spacing = 5;
            };
          }
        ];

        style = ''
          @define-color text-critical #fb4934;
          @define-color text-dark #282828;
          @define-color text-normal #ffe7ff;
          @define-color text-primary #d5c4a1;
          @define-color text-highlight #fbf1c7;

          @define-color background-critical #cc241d;
          @define-color background-highlight #bdae93;
          @define-color background-hover #a89984;
          @define-color background-primary #1d2021;

          @keyframes blink {
            to {
              color: @text-critical;
            }
          }

          #battery.critical:not(.charging){
            animation-name: blink;
            animation-direction: alternate;
            animation-duration: 1s;
            animation-iteration-count: infinite;
            animation-timing-function: linear;
          }

          #clock {
            background-color: @background-highlight;
            border-radius: 15px;
            color: @text-dark;
            margin-right: 6px;
          }

          #mode {
            color: @text-critical;
            margin: 0;
            padding: 0 0px 0px 15px;
          }

          #window {
            padding: 0 15px;
          }

          #workspaces button {
            border-radius: 5px;
            border: 0px;
            box-shadow: none;
            color: @text-primary;
            padding: 0 5px;
            margin: 0 1px;
            text-shadow: none;
          }

          #workspaces button:hover {
            background: @background-hover;
            color: @text-dark;
          }

          #workspaces button.focused {
            background-color: @background-highlight;
            color: @text-dark;
          }

          #workspaces button.urgent {
            background-color: @background-critical;
          }

          * {
            border: none;
            font-family: RobotoMono Nerd Font;
            font-size: 12px;
            font-weight: 500;
          }

          window#waybar {
            color: @text-normal;
            border-radius: 15px;
            background: @background-primary;

            /* Used during reloads */
            transition-property: background;
            transition-duration: 0.5s;
          }

          widget > * {
            border-radius: 5px;
            color: @text-primary;
            margin: 0px 2px;
            transition-duration: 0.2s;
            transition-property: background;
          }

          .modules-right > widget > * {
            padding: 0 10px;
          }

          .modules-right > widget > *:hover {
            background: @background-hover;
            color: @text-dark;
          }

          tooltip {
            background: @background-primary;
            border-radius: 15px;
          }

          tooltip label {
            color: @text-normal;
          }
        '';
      };
    })
  ];
}
