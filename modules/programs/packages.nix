{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      programs.adb.enable = true;
    })

    (lib.optionalAttrs (mode == "home-manager") {
      home.packages = with pkgs; [
        apache-directory-studio
        adoptopenjdk-icedtea-web
        alejandra
        arandr
        aria2
        argocd
        awscli2
        claws-mail
        discord
        docker-compose
        dos2unix
        evince
        fd
        feh
        ferdium
        ffmpeg
        gimp
        glab
        gnucash
        gnuplot
        go
        ipcalc
        jetbrains.datagrip
        jetbrains.idea-ultimate
        jdk
        inkscape
        imagemagick
        kubectl
        kubernetes-helm
        kustomize
        libreoffice
        maven
        minecraft
        nix-index
        nix-zsh-completions
        nixpkgs-fmt
        nixpkgs-review
        nmap
        noaa-apt
        (wrapOBS {
          plugins = [
            (obs-studio-plugins.droidcam-obs.overrideAttrs rec {
              version = "2.2.0";
              src = fetchFromGitHub {
                owner = "dev47apps";
                repo = "droidcam-obs-plugin";
                rev = version;
                sha256 = "sha256-2/NHYgoIalOty3KKSzdFfXrhwylR2XWwerJQFwA2o4o=";
              };
            })
          ];
        })
        openboard
        openldap
        openssl
        parallel
        pcmanfm
        postgresql
        pwgen
        rancher
        ripgrep
        xfce.ristretto
        rtl-sdr
        s3cmd
        signal-desktop
        slack
        speedtest-cli
        spotify
        stellarium
        stern
        super-slicer-latest
        tokei
        thunderbird
        transmission
        urlview
        vault
        velero
        virt-manager
        vlc
        warsow
        wireshark
        wpa_supplicant_gui
        x11vnc
        xsel
        yq

        vim
      ];
    })
  ];
}
