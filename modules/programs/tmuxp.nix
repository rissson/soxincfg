{
  mode,
  config,
  pkgs,
  lib,
  ...
}: let
  layouts = {
    blog = import ./tmuxp/blog.nix;
    soxincfg = import ./tmuxp/soxincfg.nix;
  };
in {
  config = lib.optionalAttrs (mode == "home-manager") {
    xdg.configFile =
      lib.mapAttrs' (name: value: {
        name = "tmuxp/${name}.json";
        value.text = builtins.toJSON value;
      })
      layouts;
  };
}
