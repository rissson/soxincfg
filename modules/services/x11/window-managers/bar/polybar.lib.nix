# TODO(low): all colors should be managed by themes
{
  config,
  pkgs,
  lib,
  ...
}: let
  script = ''
    set -euo pipefail

    readonly i3Socket=''${XDG_RUNTIME_DIR:-/run/user/$UID}/i3/ipc-socket.*
    if ! [ -S $i3Socket ]; then
      echo "The i3 socket is not available at $i3Socket"
      exit 1
    fi

    for m in $(${pkgs.xorg.xrandr}/bin/xrandr --query | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.coreutils}/bin/cut -d" " -f1); do
      echo "Starting polybar on monitor $m"
      MONITOR=$m polybar -q --log=error --reload default &
    done
  '';

  batteryConstructor = {
    device,
    fullAt,
    ...
  }: {
    name = "module/battery-${device}";
    value = lib.mkOrder config.modules.battery.order {
      type = "internal/battery";
      battery = device;
      adapter = "AC";
      full-at = fullAt;
      poll-interval = 5;
      format-charging-prefix = "⬆️";
      format-charging = "<label-charging>";
      format-charging-underline = "#ffb52a";
      label-charging = "%percentage%% %time%";
      format-discharging-prefix = "⬇️";
      format-discharging = "<label-discharging>";
      format-discharging-underline = "\${self.format-charging-underline}";
      label-discharging = "\${self.label-charging}";
      format-full-prefix = "↔️";
      format-full = "<label-full>";
      format-full-prefix-foreground = "\${colors.foreground-alt}";
      format-full-underline = "\${self.format-charging-underline}";
      label-full = "%percentage%%";
    };
  };

  timeConstructor = {
    format,
    timezone,
    prefix,
    ...
  }: {
    name = "module/time-${timezone}";
    value = lib.mkOrder config.modules.time.order {
      type = "custom/script";
      exec = "TZ=${timezone} ${pkgs.coreutils}/bin/date +'${format}'";
      interval = 1;
      format-prefix = "${prefix} ";
      format-prefix-foreground = "\${colors.foreground-alt}";
      format-underline = "#0a6cf5";
    };
  };

  networkEthConstructor = interface: {
    name = "module/network-eth-${interface}";
    value = lib.mkOrder config.modules.network.order {
      inherit interface;

      type = "internal/network";
      interval = 3;
      format-connected-underline = "#55aa55";
      format-connected-prefix = "ETH ";
      format-connected-prefix-foreground = "\${colors.foreground-alt}";
      label-connected = "%local_ip%";
      format-disconnected = "";
      format-packetloss = "<animation-packetloss> <label-connected>";
      animation-packetloss-0 = "⚠";
      animation-packetloss-0-foreground = "#ffa64c";
      animation-packetloss-1 = "📶";
      animation-packetloss-1-foreground = "#000000";
      animation-packetloss-framerate = 500;
    };
  };

  networkWlanConstructor = interface: {
    name = "module/network-wlan-${interface}";
    value = lib.mkOrder config.modules.network.order {
      inherit interface;

      type = "internal/network";
      interval = 3;
      format-connected = "<ramp-signal> <label-connected>";
      format-connected-underline = "#9f78e1";
      label-connected = "%essid% %local_ip%";
      format-disconnected = "";
      format-packetloss = "<animation-packetloss> <label-connected>";
      ramp-signal-0 = "▁";
      ramp-signal-1 = "▂";
      ramp-signal-2 = "▃";
      ramp-signal-3 = "▅";
      ramp-signal-4 = "▆";
      ramp-signal-5 = "█";
      ramp-signal-foreground = "\${colors.foreground-alt}";
      animation-packetloss-0 = "⚠";
      animation-packetloss-0-foreground = "#ffa64c";
      animation-packetloss-1 = "📶";
      animation-packetloss-1-foreground = "#000000";
      animation-packetloss-framerate = 500;
    };
  };

  modulesConfig =
    # Battery modules
    (
      lib.optionalAttrs config.modules.battery.enable
      (builtins.listToAttrs (map batteryConstructor config.modules.battery.devices))
    )
    //
    # Time modules
    (
      lib.optionalAttrs config.modules.time.enable
      (builtins.listToAttrs (map timeConstructor config.modules.time.timezones))
    )
    //
    # Network-eth module
    (
      lib.optionalAttrs config.modules.network.enable
      (builtins.listToAttrs (map networkEthConstructor config.modules.network.eth))
    )
    //
    # Network-wlan module
    (
      lib.optionalAttrs config.modules.network.enable
      (builtins.listToAttrs (map networkWlanConstructor config.modules.network.wlan))
    )
    //
    # Backlight module
    (lib.optionalAttrs config.modules.backlight.enable {
      "module/backlight" = lib.mkOrder config.modules.backlight.order {
        type = "internal/backlight";
        card = "intel_backlight";
        format = "<label> <ramp>";
        label = "%percentage%";
        # Only applies if <bar> is used
        bar-width = 10;
        bar-indicator = "|";
        bar-indicator-foreground = "#fff";
        bar-indicator-font = 2;
        bar-fill = "─";
        bar-fill-font = 2;
        bar-fill-foreground = "#9f78e1";
        bar-empty = "─";
        bar-empty-font = 2;
        bar-empty-foreground = "\${colors.foreground-alt}";
        # Only applies if <ramp> is used
        ramp-0 = "🌕";
        ramp-1 = "🌔";
        ramp-2 = "🌓";
        ramp-3 = "🌒";
        ramp-4 = "🌑";
      };
    })
    //
    # Module CPU
    (lib.optionalAttrs config.modules.cpu.enable {
      "module/cpu" = lib.mkOrder config.modules.cpu.order {
        type = "internal/cpu";
        interval = 2;
        format-prefix = "🖥️";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-underline = "#f90000";
        label = "%percentage%%";
      };
    })
    //
    # Module RAM
    (lib.optionalAttrs config.modules.ram.enable {
      "module/ram" = lib.mkOrder config.modules.ram.order {
        type = "internal/memory";
        interval = 5;
        format-prefix = "💾";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-underline = "#4bffdc";
        label = "%percentage_used%%";
      };
    })
    //
    # Module volume (pulseaudio)
    (lib.optionalAttrs config.modules.volume.enable {
      "module/volume" = lib.mkOrder config.modules.volume.order {
        type = "internal/pulseaudio";
        format-volume = "<ramp-volume> <label-volume> <bar-volume>";
        label-volume = "%percentage%%";
        label-volume-foreground = "\${root.foreground}";
        label-muted = "🔇 muted";
        label-muted-foreground = "#666";
        bar-volume-width = 10;
        bar-volume-foreground-0 = "#55aa55";
        bar-volume-foreground-1 = "#55aa55";
        bar-volume-foreground-2 = "#55aa55";
        bar-volume-foreground-3 = "#55aa55";
        bar-volume-foreground-4 = "#55aa55";
        bar-volume-foreground-5 = "#f5a70a";
        bar-volume-foreground-6 = "#ff5555";
        bar-volume-gradient = true;
        bar-volume-indicator = "|";
        bar-volume-indicator-font = 2;
        bar-volume-fill = "─";
        bar-volume-fill-font = 2;
        bar-volume-empty = "─";
        bar-volume-empty-font = 2;
        bar-volume-empty-foreground = "\${colors.foreground-alt}";
        ramp-volume-0 = "🔈";
        ramp-volume-1 = "🔉";
        ramp-volume-2 = "🔊";
      };
    })
    //
    # Module keyboardLayout
    (lib.optionalAttrs config.modules.keyboardLayout.enable {
      "module/keyboardLayout" = lib.mkOrder config.modules.keyboardLayout.order {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";
        format-prefix = "";
        format-prefix-foreground = "\${colors.foreground-alt}";
        format-prefix-underline = "\${colors.secondary}";
        label-layout = "%layout%";
        label-layout-underline = "\${colors.secondary}";
        label-indicator-padding = 1;
        label-indicator-margin = 1;
        label-indicator-background = "\${colors.secondary}";
        label-indicator-underline = "\${colors.secondary}";
      };
    });
in {
  package = pkgs.polybar.override {
    i3Support = true;
    pulseSupport = true;
  };
  inherit script;

  config =
    modulesConfig
    // {
      "settings" = {
        pseudo-transparency = true;
        screenchange-reload = true;
      };

      "bar/default" =
        {
          inherit (config) height;

          monitor = "\${env:MONITOR:}";
          width = "100%";
          bottom = config.location == "bottom";
          radius = "0.0";
          fixed-center = false;
          background = "\${colors.background}";
          foreground = "\${colors.foreground}";
          line-size = 1;
          line-color = "#f00";
          padding-left = 0;
          padding-right = 2;

          enable-ipc = true;

          # validate the font with `fc-match '<full-font-string-here>'`
          font-0 = "Source Code Pro for Powerline:style=Regular:size=9:antialias=true";
          font-1 = "xft:Twitter Color Emoji:style=Regular:size=8";

          module-margin-left = 1;
          module-margin-right = 2;

          tray-position = "right";
          tray-padding = 5;
          scroll-up = "i3wm-wsnext";
          scroll-down = "i3wm-wsprev";
          cursor-click = "pointer";
          cursor-scroll = "ns-resize";

          modules-left = "i3";
          modules-center = "";
          modules-right = builtins.concatStringsSep " " (map (lib.removePrefix "module/") (builtins.attrNames modulesConfig));
        }
        // lib.optionalAttrs (config.dpi != null) {inherit (config) dpi;};

      "module/i3" = {
        type = "internal/i3";
        format = "<label-state> <label-mode>";
        index-sort = true;
        wrapping-scroll = false;
        strip-wsnumbers = false;

        # Only show workspaces on the same output as the bar
        pin-workspaces = true;

        label-mode-padding = 2;
        label-mode-foreground = "#000";
        label-mode-background = "\${colors.primary}";

        # focused = Active workspace on focused monitor
        label-focused = "%name%";
        label-focused-background = "\${colors.background-alt}";
        label-focused-underline = "\${colors.primary}";
        label-focused-padding = 2;

        # unfocused = Inactive workspace on any monitor
        label-unfocused = "%name%";
        label-unfocused-padding = 1;

        # visible = Active workspace on unfocused monitor
        label-visible = "%name%";
        label-visible-background = "\${self.label-focused-background}";
        label-visible-underline = "\${self.label-focused-underline}";
        label-visible-padding = "\${self.label-focused-padding}";

        # urgent = Workspace with urgency hint set
        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = 2;

        # Separator in between workspaces
        # label-separator = "|";
      };
    };
}
