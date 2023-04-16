{
  mode,
  config,
  pkgs,
  lib,
  ...
}: let
  gruvboxVersion = "3.0.1-rc.0";
  gruvboxSrc = pkgs.fetchFromGitHub {
    owner = "morhetz";
    repo = "gruvbox";
    rev = "v${gruvboxVersion}";
    sha256 = "01as1pkrlbzhcn1kyscy476w8im3g3wmphpcm4lrx7nwdq8ch7h1";
  };
in {
  config = lib.mkIf (config.soxin.settings.theme == "gruvbox-dark") (lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      xsession = lib.optionalAttrs pkgs.stdenv.isLinux {
        windowManager = {
          inherit (config.soxin.themes.gruvbox-dark) i3;
        };
      };

      services.polybar.config = {
        inherit (config.soxin.themes.gruvbox-dark.polybar.extraConfig) colors;
      };

      # Taken from https://github.com/x4121/dotfiles/blob/4e73c297afe7675bc5490fbb73b8f2481cf3ca95/etc/gruvbox-dark-256.taskwarrior.theme
      programs.taskwarrior.extraConfig = ''
        # Copyright 2017, Armin Grodon.
        # Copyright 2006 - 2016, Paul Beckingham, Federico Hernandez.

        rule.precedence.color=deleted,completed,active,keyword.,tag.,project.,overdue,scheduled,due.today,due,blocked,blocking,recurring,tagged,uda.

        # General decoration
        color.label=
        color.label.sort=
        color.alternate=on color237
        color.header=color4
        color.footnote=color6
        color.warning=color0 on color3
        color.error=color1
        color.debug=color5

        # Task state
        color.completed=
        color.deleted=
        color.active=color11
        color.recurring=color4
        color.scheduled=
        color.until=
        color.blocked=color0 on color3
        color.blocking=color9 on color3

        # Project
        color.project.none=

        # Priority
        color.uda.priority.H=color13
        color.uda.priority.M=color12
        color.uda.priority.L=color14

        # Tags
        color.tag.next=
        color.tag.none=
        color.tagged=color10

        # Due
        color.due=color9
        color.due.today=color1
        color.overdue=color5

        # Report: burndown
        color.burndown.done=color0 on color2
        color.burndown.pending=color0 on color1
        color.burndown.started=color0 on color3

        # Report: history
        color.history.add=color0 on color1
        color.history.delete=color0 on color3
        color.history.done=color0 on color2

        # Report: summary
        color.summary.background=on color0
        color.summary.bar=color0 on color2

        # Command: calendar
        color.calendar.due=color0 on color3
        color.calendar.due.today=color0 on color166
        color.calendar.overdue=color0 on color1
        color.calendar.holiday=color0 on color6
        color.calendar.today=color0 on color4
        color.calendar.weekend=color14 on color0
        color.calendar.weeknumber=color12

        # Command: sync
        color.sync.added=color10
        color.sync.changed=color11
        color.sync.rejected=color9

        # Command: undo
        color.undo.after=color2
        color.undo.before=color1
      '';
    })
  ]);
}
