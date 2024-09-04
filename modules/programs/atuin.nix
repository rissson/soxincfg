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
        enableZshIntegration = true;
        flags = [
          "--disable-up-arrow"
        ];
        settings = {
          sync_address = "https://atuin.lama-corp.space";
          update_check = false;
          sync = {
            records = true;
          };
          daemon = {
            enabled = true;
          };
        };
      };

      systemd.user.services.atuin-daemon = lib.mkIf config.programs.atuin.enable {
        Unit = {Description = "atuin daemon";};

        Install = {WantedBy = ["default.target"];};

        Service = {
          Restart = "on-failure";
          Type = "exec";
          Slice = "session.slice";
          ExecStart = "${config.programs.atuin.package}/bin/atuin daemon";
        };
      };
    })
  ];
}
