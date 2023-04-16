{
  mode,
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      soxin.programs.git = {
        enable = true;
        userName = "Marc 'risson' Schmitt";
        userEmail = "marc.schmitt@risson.space";
        gpgSigningKey = "marc.schmitt@risson.space";
        lfs.enable = true;
      };
    }

    (lib.optionalAttrs (mode == "home-manager") {
      programs.git = {
        aliases = {
          aa = "add --all .";
          aap = "!git aa -p";
          amend = "commit --amend";
          b = "branch";
          cb = "checkout -b";
          ci = "commit -s";
          ciam = "commit -a -s -m";
          cim = "commit -s -m";
          co = "checkout";
          cob = "checkout -b";
          coke = "commit -a -s -m";
          cokewogpg = "commit --no-gpg-sign -a -s -m";
          com = "checkout $(git default-branch)";
          credit = ''!f() { git commit --amend --author "$1 <$2>" -C HEAD; }; f'';
          dc = "diff --cached";
          default-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/";
          di = "diff";
          fa = "fetch --all";
          famff = "!git fetch --all && git merge --ff-only origin/master";
          famm = "!git fetch --all && git merge origin/master";
          faro = "!git fetch --all && git rebase origin/master";
          generate-patch = "!git-format-patch --patch-with-stat --raw --signoff";
          l = "log --graph --pretty=format':%C(yellow)%h %Cgreen%G?%Cblue%d%Creset %s %C(white) %an, %ar%Creset'";
          lol = "log --pretty=oneline --abbrev-commit --graph --decorate --all";
          ls-ignored = "ls-files --others -i --exclude-standard";
          pob = ''!f() { git push --set-upstream "''${1:-origin}" "$(git symbolic-ref HEAD)"; }; f'';
          pobf = ''!f() { git push --set-upstream --force "''${1:-origin}" "$(git symbolic-ref HEAD)"; }; f'';
          sp = "pull --rebase --autostash";
          st = "status";
          unstage = "reset HEAD --";
          who = "shortlog -s -s";
        };

        extraConfig = {
          apply = {
            whitespace = "strip";
          };

          branch = {
            autosetuprebase = "always";
          };

          color = {
            pager = true;
            ui = "auto";
          };

          core = {
            editor = "vim";
          };

          diff = {
            colorMoved = "default";
          };

          format = {
            signOff = true;
          };

          push = {
            default = "simple";
          };

          pull = {
            rebase = true;
          };
        };

        ignores = [
          # Direnv #
          ##########
          ".direnv/"

          # Compiled source #
          ###################
          "*.[568vq]"
          "*.a"
          "*.cgo1.go"
          "*.cgo2.c"
          "*.class"
          "*.dll"
          "*.exe"
          "*.exe"
          "*.o"
          "*.so"
          "[568vq].out"
          "_cgo_defun.c"
          "_cgo_export.*"
          "_cgo_gotypes.go"
          "_obj"
          "_test"
          "_testmain.go"

          # Ruby/Rails #
          ##############
          "**.orig"
          "*.gem"
          "*.rbc"
          "*.sassc"
          ".bundle/"
          ".sass-cache/"
          ".yardoc"
          "/public/assets/"
          "/public/index.html"
          "/public/system/*"
          "/vendor/bundle/"
          "_yardoc"
          "app/assets/stylesheets/scaffolds.css.scss"
          "capybara-*.html"
          "config/*.yml"
          "coverage/"
          "lib/bundler/man/"
          "pickle-email-*.html"
          "pkg/"
          "rerun.txt"
          "spec/reports/"
          "spec/tmp/*"
          "test/tmp/"
          "test/version_tmp/"
          "tmp/*"
          "tmp/**/*"

          # Packages #
          ############
          "*.7z"
          "*.bzip"
          "*.deb"
          "*.dmg"
          "*.egg"
          "*.gem"
          "*.gz"
          "*.iso"
          "*.jar"
          "*.lzma"
          "*.rar"
          "*.rpm"
          "*.tar"
          "*.xpi"
          "*.xz"
          "*.zip"

          # Logs and databases #
          ######################
          "*.log"
          "*.sqlite[0-9]"

          # OS generated files #
          ######################
          ".DS_Store"
          ".Spotlight-V100"
          ".Trashes/"
          "._*"
          ".directory"
          "Desktop.ini"
          "Icon?"
          "Thumbs.db"
          "ehthumbs.db"

          # Text-Editors files #
          ######################
          "*.bak"
          "*.pydevproject"
          "*.tmp"
          "*.tmproj"
          "*.tmproject"
          "*.un~"
          "*~"
          "*~.nib"
          ".*.sw[a-z]"
          ".\#*"
          ".classpath/"
          ".cproject/"
          ".elc/"
          ".loadpath/"
          ".metadata/"
          ".project/"
          ".redcar/"
          ".settings/"
          ".ycm_extra_conf.py"
          "/.emacs.desktop"
          "/.emacs.desktop.lock"
          "Session.vim"
          "\#*"
          "\#*\#"
          "auto-save-list/"
          "local.properties"
          "nbactions.xml"
          "nbproject/"
          "tmtags/"
          "tramp/"

          # Other Version Control Systems #
          #################################
          ".svn/"

          # Invert gitignore (Should be last) #
          #####################################
          "!.keep"
          "!.gitkeep"
          "!.gitignore"
        ];

        includes = [
          {path = "~/.gitconfig.secrets";}
          {
            condition = "gitdir:~/authentik/";
            contents = {
              user = {
                email = "marc@goauthentik.io";
                signingkey = "marc@goauthentik.io";
              };
            };
          }
          {
            condition = "gitdir:~/cri/";
            contents = {
              user = {
                email = "risson@cri.epita.fr";
                signingkey = "risson@cri.epita.fr";
              };
            };
          }
          {
            condition = "gitdir:~/lama-corp/";
            contents = {
              user = {
                email = "marc.schmitt@lama-corp.space";
                signingkey = "marc.schmitt@lama-corp.space";
              };
            };
          }
          {
            condition = "gitdir:~/prologin/";
            contents = {
              user = {
                email = "marc.schmitt@prologin.org";
                signingkey = "marc.schmitt@prologin.org";
              };
            };
          }
        ];
      };

      home.packages = with pkgs; [
        git-extras
        git-open
      ];
    })
  ];
}
