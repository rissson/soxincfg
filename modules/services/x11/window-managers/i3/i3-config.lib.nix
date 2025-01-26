{
  pkgs,
  lib,
}: let
  defaultModifier = "Mod4"; # <Super>
  secondModifier = "Shift";
  thirdModifier = "Mod1"; # <Alt>

  nosid = "--no-startup-id";

  locker = "${pkgs.xautolock}/bin/xautolock -locknow && sleep 1";

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

  autoStart = pkgs.writeScript "i3-autostart.sh" ''
    #! /usr/bin/env bash
    set -euo pipefail
    # Wait for the rest to complete
    ${pkgs.coreutils}/bin/sleep 5
    # Workspace 1
    ${pkgs.i3}/bin/i3-msg "workspace ${ws1}"
    # TODO: try to restore layout using append_layout
    ${pkgs.i3}/bin/i3-msg "layout tabbed"
    ${pkgs.alacritty}/bin/alacritty -t htop -e ${pkgs.htop}/bin/htop &
    ${pkgs.coreutils}/bin/sleep 1
  '';
in {
  enable = true;
  package = pkgs.i3;

  config = {
    modifier = defaultModifier;

    fonts = {
      names = ["Source Code Pro for Powerline"];
      size = 8.0;
    };

    bars = []; # We are using Polybar, so no bar should be defined

    window = {
      titlebar = false; # Configure border style <pixel xx>
      border = 0; # Configure border style <xx 0>
      hideEdgeBorders = "smart"; # Hide borders
    };

    floating = {
      titlebar = true; # Configure border style <normal xx>
      border = 2; # Configure border style <xx 2>
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

    startup = [
      {
        command = "${autoStart}";
        always = false;
        notification = false;
      }
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
      "${defaultModifier}+Return" = "exec TERMINAL=alacritty i3-sensible-terminal";
      # kill focused window
      "${defaultModifier}+${secondModifier}+Q" = "kill";
      # start dmenu (a program launcher), which is actually rofi
      "${defaultModifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show run";
      "${defaultModifier}+s" = "exec ${pkgs.rofi}/bin/rofi -show ssh";
      # list open windows to switch to
      "${thirdModifier}+Tab" = "exec ${pkgs.rofi}/bin/rofi -show window";
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
      "${defaultModifier}+t" = "split h;exec notify-send 'tile horizontally'";
      "${defaultModifier}+v" = "split v;exec notify-send 'tile vertically'";
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
      "${defaultModifier}+${secondModifier}+E" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'\"";
      # lock screen
      "${defaultModifier}+equal" = "exec ${nosid} ${locker}";
      # hide/unhide polybar
      "${defaultModifier}+m" = "exec ${nosid} polybar-msg cmd toggle";
      # custom shortcuts for applications
      "${defaultModifier}+F1" = "exec firefox";
      "${defaultModifier}+F4" = "exec pcmanfm";
      # pulseaudio controls
      # "XF86AudioRaiseVolume" = "exec ${nosid} ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec ${nosid} ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
      # "XF86AudioLowerVolume" = "exec ${nosid} ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ false, exec ${nosid} ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "exec ${nosid} ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      # screenshots
      "Print" = "exec ${nosid} ${pkgs.flameshot}/bin/flameshot full -c -p \"/home/risson/Pictures/Screenshots\"";
      "${defaultModifier}+Print" = "exec ${nosid} flameshot gui";
      # brightness
      "XF86MonBrightnessUp" = "exec ${nosid} ${pkgs.brightnessctl}/bin/brightnessctl s 5%+";
      "XF86MonBrightnessDown" = "exec ${nosid} ${pkgs.brightnessctl}/bin/brightnessctl s 5%-";
      "${secondModifier}+XF86MonBrightnessUp" = "exec ${nosid} ${pkgs.brightnessctl}/bin/brightnessctl s 1%+";
      "${secondModifier}+XF86MonBrightnessDown" = "exec ${nosid} ${pkgs.brightnessctl}/bin/brightnessctl s 1%-";
      # sleep
      "XF86PowerOff" = "exec ${nosid} ${locker} && systemctl suspend";
    };
  };
  extraConfig = ''
    workspace_auto_back_and_forth yes
  '';
}
