{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    nur.url = "github:nix-community/NUR";
    fup.url = "github:gytis-ivaskevicius/flake-utils-plus/v1.3.1";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    soxin = {
      url = "github:SoxinOS/soxin";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs-unstable";
        home-manager.follows = "home-manager";
        nur.follows = "nur";
        flake-utils-plus.follows = "fup";
      };
    };

    nixpie = {
      url = "git+https://gitlab.cri.epita.fr/cri/infrastructure/nixpie.git";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgsUnstable.follows = "nixpkgs-unstable";
        nixpkgsMaster.follows = "nixpkgs-master";
      };
    };
  };

  outputs = inputs @ {
    self,
    soxin,
    nixpie,
    nixpkgs,
    fup,
    ...
  }:
    soxin.lib.mkFlake {
      inherit self inputs;

      supportedSystems = ["x86_64-linux" "x86_64-darwin"];

      channelsConfig = {
        allowUnfree = true;
      };
      sharedOverlays = [
        inputs.alejandra.overlay
        nixpie.overlays.exec-tools
        nixpie.overlays.nixpie-utils
        nixpie.overlays.pam_afs_session
      ];
      channels = {
        nixpkgs = {
          input = inputs.nixpkgs;
          overlaysBuilder = channels: [
            (final: prev: {
              inherit
                (channels.nixpkgs-unstable)
                awscli
                nix-diff
                shellcheck
                ;
            })
          ];
        };
        nixpkgs-unstable = {
          input = inputs.nixpkgs-unstable;
        };
        nixpkgs-master = {
          input = inputs.nixpkgs-master;
        };
      };

      nixosModules =
        (import ./modules)
        // {
          profiles = import ./profiles;
          default = import ./modules/soxincfg.nix;
        };

      globalSpecialArgs = {
        inherit inputs;
      };
      extraGlobalModules = [
        self.nixosModules.profiles.core
        self.nixosModules.default
      ];
      extraNixosModules = [
        inputs.impermanence.nixosModules.impermanence
      ];

      hostDefaults = {
        channelName = "nixpkgs";
      };
      hosts = import ./hosts inputs;

      outputsBuilder = channels: {
        devShell = channels.nixpkgs.mkShell {
          buildInputs = with channels.nixpkgs; [
            alejandra
            awscli
            git
            nix-diff
            pre-commit
            shellcheck
          ];
        };
      };
    };
}
