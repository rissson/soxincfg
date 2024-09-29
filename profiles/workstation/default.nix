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

      programs.steam = {
        enable = true;
      };

      programs.gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 20;
            ioprio = 0;
          };
          gpu = {
            gpu_device = 1;
            amd_performance_level = "high";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        protontricks
      ];
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
      services.flameshot.enable = true;
    })
  ];
}
