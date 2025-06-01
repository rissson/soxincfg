{
  mode,
  config,
  pkgs,
  lib,
  ...
}: let
  functions = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "zsh-functions";
    version = "0.0.2";
    src = ./functions;
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p $out
      cp $src/* $out/
      rm -f $out/default.nix
      substituteInPlace $out/kcc \
        --subst-var-by kubectl ${pkgs.kubectl}/bin/kubectl

      substituteInPlace $out/kcn \
        --subst-var-by kubectl ${pkgs.kubectl}/bin/kubectl

      substituteInPlace $out/register_u2f \
        --subst-var-by pamu2fcfg_bin ${pkgs.pam_u2f}/bin/pamu2fcfg
    '';
  };

  ohMyZsh = {
    enable = true;
    plugins = [
      "command-not-found"
      "git"
      "sudo"
    ];
  };

  shellInit =
    ''
      source "${pkgs.nur.repos.kalbasit.ls-colors}/ls-colors/bourne-shell.sh"
    ''
    + (builtins.readFile (pkgs.replaceVars ./init-extra.zsh {
      fortune_bin = "${pkgs.fortune}/bin/fortune";
      less_bin = "${pkgs.less}/bin/less";
    }));
in {
  config = lib.mkMerge [
    {
      soxin.programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        plugins = [
          {
            name = "zsh-completions";
            src = pkgs.zsh-completions;
          }
          {
            name = "zsh-history-substring-search";
            file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
            src = pkgs.zsh-history-substring-search;
          }
          {
            name = "zsh-syntax-highlighting";
            src = pkgs.zsh-syntax-highlighting;
          }
          {
            name = "nix-shell";
            src = pkgs.zsh-nix-shell;
          }
          {
            name = "functions";
            src = functions;
          }
        ];
      };

      programs.zsh = {
        shellAliases = {
          k = "kubectl";
          ll = "ls -lha";
          rot13 = "tr \"[A-Za-z]\" \"[N-ZA-Mn-za-m]\"";
          serve_this = "${pkgs.python3}/bin/python -m http.server";
          tf = "terraform";
          v = "nvim";
          vi = "nvim";
          vim = "nvim";

          grep = "grep --color=auto";

          history = "fc -il 1";

          t = "task";
          eod = "task due:eod";
          tomorrow = "task due:sod";
          weekend = "task \\(due:saturday or due:sunday or due:mondayT00:00\\)";
        };
      };
    }

    (lib.optionalAttrs (mode == "NixOS") {
      programs.zsh = {
        histSize = 1000000000;
        inherit ohMyZsh;
      };
    })

    (lib.optionalAttrs (mode == "home-manager") {
      programs.zsh = {
        autocd = true;
        oh-my-zsh = ohMyZsh;
        history = {
          expireDuplicatesFirst = true;
          save = 100000000;
          size = 1000000000;
        };

        initContent = shellInit;
      };

      programs.command-not-found.enable = true;
    })
  ];
}
