{
  mode,
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      documentation = {
        dev.enable = true;
        man.generateCaches = true;
      };

      boot.supportedFilesystems = ["nfs"];

      programs.steam.enable = true;
    })

    (lib.optionalAttrs (mode == "NixOS" || mode == "darwin") {
      home-manager.users = {
        risson = {inputs, ...}: {
          imports = [
            inputs.self.nixosModules.profiles.workstation
          ];
        };
      };
    })

    (lib.optionalAttrs (mode == "home-manager") {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
      };
      services.flameshot.enable = pkgs.stdenv.isLinux;
    })
  ];
}
