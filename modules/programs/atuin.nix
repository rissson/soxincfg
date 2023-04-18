{
  mode,
  config,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "home-manager") {
      programs.atuin = {
        enable = true;
        # TODO: uncomment once home-manager 23.05
        enableZshIntegration = false;
        # enableZshIntegration = true;
        # flags = [
        #   "--disable-up-arrow"
        # ];
        settings = {
          sync_address = "https://atuin.lama-corp.space";
          update_check = false;
        };
      };

      # TODO: remove once home-manager 23.05
      programs.zsh.initExtra = ''
        if [[ $options[zle] = on ]]; then
          eval "$(${config.programs.atuin.package}/bin/atuin init zsh --disable-up-arrow)"
        fi
      '';
    })
  ];
}
