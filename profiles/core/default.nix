{
  mode,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkMerge optionalAttrs optionals;

  packages = with pkgs;
    [
      bc
      file
      gnumake
      gptfdisk
      htop
      iftop
      inetutils
      iotop
      jq
      killall
      ldns
      lsof
      lshw
      mbuffer
      mtr
      ncdu
      pciutils
      pv
      screen
      smartmontools
      tcpdump
      tree
      unzip
      usbutils
      vim
      wget
      zip
    ]
    ++ (optionals (mode == "NixOS") [
      tcptraceroute
      traceroute
    ]);
in {
  config = mkMerge [
    {
      soxin = {
        settings = {
          keyboard = {
            layouts = [
              {
                x11 = {
                  layout = "fr";
                  variant = "bepo";
                };
                console = {keyMap = "fr-bepo";};
              }
              {
                x11 = {
                  layout = "us";
                  variant = "intl";
                };
              }
              {
                x11 = {layout = "us";};
              }
            ];
            enableAtBoot = true;
          };
          theme = "gruvbox-dark";
        };
      };
    }

    (optionalAttrs (mode == "NixOS") {
      i18n.defaultLocale = "en_US.UTF-8";
      time.timeZone = "Europe/Paris";

      console.font = "Lat2-Terminus16";
      console.keyMap = lib.mkForce "us";

      nix = {
        settings = {
          auto-optimise-store = true;
          sandbox = true;
          system-features = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          trusted-users = ["root" "@wheel" "@builders"];
          substituters = [
            "https://nix-cache.s3.lama-corp.space"
            "https://nix-cache.s3.prologin.org"
            "https://s3.cri.epita.fr/cri-nix-cache.s3.cri.epita.fr"
          ];
          trusted-public-keys = [
            "cache.nix.lama-corp.space:zXDtep4OcIi2/hkqNmA1UkAoDTGBZE/YvEQdT750L1M="
            "cache.nix.prologin.org:OZMs46jaN4mLZ3Tbb1oFC4JRuyNYZy29I+JoDKjLrh0="
            "cache.nix.cri.epita.fr:qDIfJpZWGBWaGXKO3wZL1zmC+DikhMwFRO4RVE6VVeo="
          ];
        };
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 10d";
        };
        distributedBuilds = true;
      };

      security.protectKernelImage = true;

      services.fwupd.enable = true;

      hardware.enableRedistributableFirmware = true;

      environment.systemPackages = packages;

      system.stateVersion = "22.11";
    })

    (optionalAttrs (mode == "home-manager") {
      home.packages = packages;

      home.stateVersion = "22.11";
    })
  ];
}
