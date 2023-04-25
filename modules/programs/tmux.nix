{
  mode,
  config,
  pkgs,
  lib,
  ...
}: let
  vimAwarness = ''
    # Smart pane switching with awareness of Vim splits.
    # See: https://github.com/christoomey/vim-tmux-navigator
    is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
    bind-key -n M-n if-shell "$is_vim" "send-keys M-n"  "select-pane -L"
    bind-key -n M-e if-shell "$is_vim" "send-keys M-e"  "select-pane -D"
    bind-key -n M-i if-shell "$is_vim" "send-keys M-i"  "select-pane -U"
    bind-key -n M-o if-shell "$is_vim" "send-keys M-o"  "select-pane -R"
  '';
in {
  config = lib.mkMerge [
    {
      soxin.programs.tmux = {
        enable = true;
        extraConfig = ''
          ${vimAwarness}

          #
          # Settings
          #

          # don't allow the terminal to rename windows
          set-window-option -g allow-rename off

          # show the current command in the border of the pane
          set -g pane-border-status "top"
          set -g pane-border-format "#P: #{pane_current_command}"

          # Terminal emulator window title
          set -g set-titles on
          set -g set-titles-string '#S:#I.#P #W'

          # Status Bar
          set-option -g status on

          # Notifying if other windows has activities
          #setw -g monitor-activity off
          set -g visual-activity on

          # Trigger the bell for any action
          set-option -g bell-action any
          set-option -g visual-bell off

          # No Mouse!
          set -g mouse off

          # Last active window
          bind C-t last-window
          bind C-r switch-client -l
          # bind C-n next-window
          bind C-n switch-client -p
          bind C-o switch-client -n

          ${lib.optionalString pkgs.stdenv.isLinux ''set  -g default-terminal "tmux-256color"''}
        '';

        plugins = with pkgs.tmuxPlugins; [
          prefix-highlight
          fzf-tmux-url
        ];
      };
    }

    (lib.optionalAttrs (mode == "NixOS" || mode == "home-manager") {
      programs.tmux = {
        clock24 = true;
        customPaneNavigationAndResize = true;
        escapeTime = 0;
        historyLimit = 10000;
        keyMode = "vi";
        shortcut = "t";
      };
    })

    (lib.optionalAttrs (mode == "home-manager") {
      programs.tmux = {
        tmuxp = {
          enable = true;
        };
      };
    })
  ];
}
