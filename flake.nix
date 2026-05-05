{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    nur.url = "github:nix-community/NUR";
    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
    alejandra.url = "github:kamadorueda/alejandra";
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
  };

  outputs = inputs @ {
    self,
    soxin,
    nixpkgs,
    ...
  }:
    soxin.lib.mkFlake {
      inherit self inputs;

      supportedSystems = ["x86_64-linux" "x86_64-darwin"];

      channelsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = [
          # required for teamspeak3
          "qtwebengine-5.15.19"
          # Only used as a client
          "vault-1.14.10"
        ];
      };
      sharedOverlays = [
        inputs.alejandra.overlay
      ];
      channels = {
        nixpkgs = {
          input = inputs.nixpkgs;
          overlaysBuilder = channels: [
            (_: _: {
              inherit
                (channels.nixpkgs-unstable)
                atuin
                awscli2
                kicad
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
            awscli2
            git
            nix-diff
            pre-commit
            shellcheck
          ];
        };
      };
    };
}
