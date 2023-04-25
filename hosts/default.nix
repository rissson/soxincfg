{
  self,
  nixpkgs,
  ...
} @ inputs: let
  inherit (nixpkgs) lib;
  genAttrs' = func: values: builtins.listToAttrs (map func values);

  getHostname = path: lib.lists.last (lib.splitString "/" path);
  getDomain = path: (builtins.head (lib.splitString "/" path)) + ".lama.tel";
  getConfiguration = path: "${toString ./.}/${path}/configuration.nix";

  mkHosts = hosts:
    lib.lists.foldl' (l: r: lib.trivial.mergeAttrs l r) {} (builtins.attrValues (
      lib.mapAttrs
      (
        system: paths:
          genAttrs'
          (path: {
            name = getHostname path;
            value = {
              inherit system;
              modules = [
                ({
                  mode,
                  lib,
                  ...
                }: {
                  config = lib.mkMerge [
                    (lib.optionalAttrs (mode == "NixOS") {
                      networking = {
                        hostName = lib.mkForce (getHostname path);
                        domain = lib.mkForce (getDomain path);
                      };
                    })
                  ];
                })
                (getConfiguration path)
              ];
            };
          })
          paths
      )
      hosts
    ));

  nixosHosts' = {
    x86_64-linux = [
      "bar/horse"
      # "rsn/hedgehog"
    ];
  };

  darwinHosts' = {
    aarch64-darwin = [
      "rsn/deer"
    ];
  };
in {
  darwinHosts = mkHosts darwinHosts';
  nixosHosts = mkHosts nixosHosts';
}
