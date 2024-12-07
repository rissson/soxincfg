{
  mode,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      programs.neovim = {
        enable = true;
        withPython3 = true;
        withNodeJs = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        extraPackages = with pkgs; [
          basedpyright
          cargo
          clang
          deadnix
          lua-language-server
          ruff
          tree-sitter
          statix
        ];
      };

      xdg.configFile."nvim" = {
        source = ./config;
        recursive = true;
      };
    })
  ];
}
