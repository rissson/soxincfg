{
  mode,
  lib,
  config,
  pkgs,
  ...
}: let
  defaultModifier = "Mod4"; # <Super>
  secondModifier = "Shift";
  thirdModifier = "Mod1"; # <Alt>

  mode_resize = "resize";

  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8";
  ws9 = "9";
  ws10 = "10";
  ws11 = "11";
in {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      programs.sway = {
        enable = true;
        xwayland.enable = true;
      };

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      environment.pathsToLink = ["/share/icons"];

      programs.uwsm = {
        enable = true;
        waylandCompositors = {
          sway = {
            prettyName = "Sway";
            comment = "Sway compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/sway";
          };
        };
      };
    })

    (lib.optionalAttrs (mode == "home-manager") {
      wayland.windowManager.sway = {
        enable = true;

        systemd.enable = false;
        xwayland = true;
        swaynag.enable = true;

        config = {
          input = {
            "*" = {
              repeat_delay = "200";
              repeat_rate = "25";

              xkb_layout = "us,us";
              xkb_variant = "intl,";
              xkb_options = "grp:alt_caps_toggle,caps:escape";
              xkb_numlock = "enabled";
            };
          };

          modifier = defaultModifier;

          fonts = {
            names = ["Source Code Pro for Powerline"];
            size = 8.0;
          };

          bars = [];

          window = {
            titlebar = false;
            border = 0;
            hideEdgeBorders = "smart";
          };

          floating = {
            titlebar = true;
            border = 2;
            criteria = [
              {class = "qt5ct";}
              {class = "Qtconfig-qt4";}
              {title = "File Transfer*";}
              {title = "i3_help";}
              {title = "Musescore: Play Panel";}
            ];
            modifier = defaultModifier;
          };

          focus = {
            followMouse = true;
            mouseWarping = true;
            newWindow = "urgent";
          };

          workspaceLayout = "default";
          workspaceAutoBackAndForth = true;

          startup = [
            {command = "uwsm finalize ${lib.concatStringsSep " " config.wayland.windowManager.sway.systemd.variables}";}
          ];

          modes = {
            "${mode_resize}" = {
              "h" = "resize shrink width 10 px or 10 ppt";
              "j" = "resize grow height 10 px or 10 ppt";
              "k" = "resize shrink height 10 px or 10 ppt";
              "l" = "resize grow width 10 px or 10 ppt";
              "Left" = "resize shrink width 10 px or 10 ppt";
              "Down" = "resize grow height 10 px or 10 ppt";
              "Up" = "resize shrink height 10 px or 10 ppt";
              "Right" = "resize grow width 10 px or 10 ppt";

              "Return" = "mode default";
              "Escape" = "mode default";
            };
          };
          keybindings = {
            # start a terminal
            "${defaultModifier}+Return" = "exec uwsm app -- alacritty";
            # kill focused window
            "${defaultModifier}+${secondModifier}+Q" = "kill";
            # start dmenu (a program launcher), which is actually rofi
            "${defaultModifier}+d" = "exec uwsm app -- ${pkgs.rofi}/bin/rofi -show run -run-command \"uwsm app -- {cmd}\"";
            "${defaultModifier}+s" = "exec uwsm app -- ${pkgs.rofi}/bin/rofi -show ssh -run-command \"uwsm app -- {cmd}\"";
            # change focus
            "${defaultModifier}+h" = "focus left";
            "${defaultModifier}+j" = "focus down";
            "${defaultModifier}+k" = "focus up";
            "${defaultModifier}+l" = "focus right";
            "${defaultModifier}+Left" = "focus left";
            "${defaultModifier}+Down" = "focus down";
            "${defaultModifier}+Up" = "focus up";
            "${defaultModifier}+Right" = "focus right";
            # move focused window
            "${defaultModifier}+${secondModifier}+H" = "move left";
            "${defaultModifier}+${secondModifier}+J" = "move down";
            "${defaultModifier}+${secondModifier}+K" = "move up";
            "${defaultModifier}+${secondModifier}+L" = "move right";
            "${defaultModifier}+${secondModifier}+Left" = "move left";
            "${defaultModifier}+${secondModifier}+Down" = "move down";
            "${defaultModifier}+${secondModifier}+Up" = "move up";
            "${defaultModifier}+${secondModifier}+Right" = "move right";
            # workspace back and forth (with/without active container)
            "${defaultModifier}+b" = "workspace back_and_forth";
            "${defaultModifier}+${secondModifier}+B" = "move container to workspace back_and_forth; workspace back_and_forth";
            # split orientation
            "${defaultModifier}+t" = "split h; exec uwsm app -- notify-send 'tile horizontally'";
            "${defaultModifier}+v" = "split v; exec uwsm app -- notify-send 'tile vertically'";
            # enter fullscreen mode for the focused container
            "${defaultModifier}+f" = "fullscreen toggle";
            # change container layout (stacked, tabbed, toggle split)
            "${defaultModifier}+w" = "layout tabbed";
            "${defaultModifier}+e" = "layout toggle split";
            # toggle tiling / floating
            "${defaultModifier}+${secondModifier}+space" = "floating toggle";
            # change focus between tiling / floating windows
            "${defaultModifier}+space" = "focus mode_toggle";
            # focus the parent container
            "${defaultModifier}+a" = "focus parent";
            # switch to workspace
            "${defaultModifier}+1" = "workspace ${ws1}";
            "${defaultModifier}+2" = "workspace ${ws2}";
            "${defaultModifier}+3" = "workspace ${ws3}";
            "${defaultModifier}+4" = "workspace ${ws4}";
            "${defaultModifier}+5" = "workspace ${ws5}";
            "${defaultModifier}+6" = "workspace ${ws6}";
            "${defaultModifier}+7" = "workspace ${ws7}";
            "${defaultModifier}+8" = "workspace ${ws8}";
            "${defaultModifier}+9" = "workspace ${ws9}";
            "${defaultModifier}+0" = "workspace ${ws10}";
            "${defaultModifier}+minus" = "workspace ${ws11}";
            # move focused container to workspace
            "${defaultModifier}+Ctrl+1" = "move container to workspace ${ws1}";
            "${defaultModifier}+Ctrl+2" = "move container to workspace ${ws2}";
            "${defaultModifier}+Ctrl+3" = "move container to workspace ${ws3}";
            "${defaultModifier}+Ctrl+4" = "move container to workspace ${ws4}";
            "${defaultModifier}+Ctrl+5" = "move container to workspace ${ws5}";
            "${defaultModifier}+Ctrl+6" = "move container to workspace ${ws6}";
            "${defaultModifier}+Ctrl+7" = "move container to workspace ${ws7}";
            "${defaultModifier}+Ctrl+8" = "move container to workspace ${ws8}";
            "${defaultModifier}+Ctrl+9" = "move container to workspace ${ws9}";
            "${defaultModifier}+Ctrl+0" = "move container to workspace ${ws10}";
            "${defaultModifier}+Ctrl+minus" = "move container to workspace ${ws11}";
            # move to workspace with focused container
            "${defaultModifier}+${secondModifier}+1" = "move container to workspace ${ws1}; workspace ${ws1}";
            "${defaultModifier}+${secondModifier}+2" = "move container to workspace ${ws2}; workspace ${ws2}";
            "${defaultModifier}+${secondModifier}+3" = "move container to workspace ${ws3}; workspace ${ws3}";
            "${defaultModifier}+${secondModifier}+4" = "move container to workspace ${ws4}; workspace ${ws4}";
            "${defaultModifier}+${secondModifier}+5" = "move container to workspace ${ws5}; workspace ${ws5}";
            "${defaultModifier}+${secondModifier}+6" = "move container to workspace ${ws6}; workspace ${ws6}";
            "${defaultModifier}+${secondModifier}+7" = "move container to workspace ${ws7}; workspace ${ws7}";
            "${defaultModifier}+${secondModifier}+8" = "move container to workspace ${ws8}; workspace ${ws8}";
            "${defaultModifier}+${secondModifier}+9" = "move container to workspace ${ws9}; workspace ${ws9}";
            "${defaultModifier}+${secondModifier}+0" = "move container to workspace ${ws10}; workspace ${ws10}";
            "${defaultModifier}+${secondModifier}+minus" = "move container to workspace ${ws11}; workspace ${ws11}";
            # move workspace between monitors
            "${defaultModifier}+Ctrl+comma" = "move workspace to output left";
            "${defaultModifier}+Ctrl+period" = "move workspace to output right";
            # reload the configuration file
            "${defaultModifier}+${secondModifier}+C" = "reload";
            # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
            "${defaultModifier}+${secondModifier}+R" = "restart";
            # switch to mode resize, to resize window
            "${defaultModifier}+r" = "mode ${mode_resize}";
            # exit i3 (logs you out of your X session)
            "${defaultModifier}+${secondModifier}+E" = "exec uwsm app -- swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'swaymsg exit'";
            # lock screen
            "${defaultModifier}+equal" = "exec uwsm app -- loginctl lock-session";
            # custom shortcuts for applications
            "${defaultModifier}+F1" = "exec uwsm app -- firefox";
            "${defaultModifier}+F4" = "exec uwsm app -- pcmanfm";
            # pulseaudio controls
            # "XF86AudioRaiseVolume" = "exec uwsm app -- ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec ${nosid} ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            # "XF86AudioLowerVolume" = "exec uwsm app -- ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec ${nosid} ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec uwsm app -- ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            # screenshots
            "Print" = "exec uwsm app -- ${pkgs.flameshot}/bin/flameshot full -c -p \"/home/risson/Pictures/Screenshots\"";
            "${defaultModifier}+Print" = "exec uwsm app -- flameshot gui";
            # brightness
            "XF86MonBrightnessUp" = "exec uwsm app -- ${pkgs.brightnessctl}/bin/brightnessctl s 5%+";
            "XF86MonBrightnessDown" = "exec uwsm app -- ${pkgs.brightnessctl}/bin/brightnessctl s 5%-";
            "${secondModifier}+XF86MonBrightnessUp" = "exec uwsm app -- ${pkgs.brightnessctl}/bin/brightnessctl s 1%+";
            "${secondModifier}+XF86MonBrightnessDown" = "exec uwsm app -- ${pkgs.brightnessctl}/bin/brightnessctl s 1%-";
            # sleep
            "XF86PowerOff" = "exec uwsm app -- systemctl suspend";
          };
        };
      };

      xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

      home.sessionVariables = {
        # See https://github.com/swaywm/sway/issues/3814
        WLR_NO_HARDWARE_CURSORS = "1";

        XDG_SESSION_TYPE = "wayland";

        SDL_VIDEODRIVER = "wayland";

        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_FORCE_DPI = "physical";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        ECORE_EVAS_ENGINE = "wayland_egl";
        ELM_ENGINE = "wayland_egl";

        _JAVA_AWT_WM_NONREPARENTING = "1";

        # fix the look of Java applications
        _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
      };

      home.packages = with pkgs; [
        wl-clipboard
      ];
    })
  ];
}
