{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      environment.systemPackages = with pkgs; [
        android-tools
      ];
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
        img2pdf
        ipcalc
        jetbrains.datagrip
        jetbrains.idea
        jdk
        inkscape
        imagemagick
        kicad
        kubectl
        kubectl-view-secret
        kubernetes-helm
        kustomize
        libreoffice
        maven
        nix-index
        nix-zsh-completions
        nixpkgs-fmt
        nixpkgs-review
        nmap
        noaa-apt
        (wrapOBS {
          plugins = [
            obs-studio-plugins.droidcam-obs
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
        # teamspeak3
        tokei
        thunderbird
        transmission_4
        vault
        velero
        virt-manager
        vlc
        wireshark
        wpa_supplicant_gui
        x11vnc
        xsel
        yq

        vim

        wineWow64Packages.stable
        winetricks
      ];
    })
  ];
}
