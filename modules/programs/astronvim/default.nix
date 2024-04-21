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
        ruff
      ];

      xdg.configFile."nvim" = {
        source = pkgs.fetchFromGitHub {
          owner = "AstroNvim";
          repo = "AstroNvim";
          rev = "v3.40.3";
          sha256 = "sha256-h019vKDgaOk0VL+bnAPOUoAL8VAkhY6MGDbqEy+uAKg=";
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
