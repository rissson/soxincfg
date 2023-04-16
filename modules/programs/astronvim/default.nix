{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      home.packages = with pkgs; [
        (neovim.override {
          withPython3 = true;
          withNodeJs = true;
          vimAlias = true;
          viAlias = true;
        })

        cargo
        ripgrep
      ];

      xdg.configFile."nvim" = {
        source = pkgs.fetchFromGitHub {
          owner = "AstroNvim";
          repo = "AstroNvim";
          rev = "v3.10.3";
          sha256 = "sha256-AFWiB947LWww/PMRaMDx5c8UE++0Gnav2tgUx6TsQK0=";
        };
        # needed to have the custom user config
        recursive = true;
      };

      xdg.configFile."nvim/lua/user" = {
        source = ./user;
      };
    })
  ];
}
