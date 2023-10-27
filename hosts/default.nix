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

  hosts = {
    x86_64-linux = [
      "bar/beaver"
      "bar/horse"
      # "rsn/hedgehog"
    ];
    x86_64-darwin = [];
  };
in
  lib.lists.foldl' (l: r: lib.trivial.mergeAttrs l r) {} (builtins.attrValues (
    lib.mapAttrs
    (
      system: paths:
        genAttrs'
        (path: {
          name = getHostname path;
          value = {
            # TODO: add builder for darwin if we are evalutating
            # `x86_64-darwin` hosts
            inherit system;
            modules = [
              # TODO: import core profile and such
              {
                networking = {
                  hostName = lib.mkForce (getHostname path);
                  domain = lib.mkForce (getDomain path);
                };
              }
              (getConfiguration path)
            ];
          };
        })
        paths
    )
    hosts
  ))
