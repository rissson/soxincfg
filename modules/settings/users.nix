{
  mode,
  config,
  pkgs,
  lib,
  ...
}: let
  makeUser = userName: {
    uid,
    isAdmin ? false,
    home ? "/home/${userName}",
    hashedPassword ? "",
    sshKeys ? [],
  }: {
    inherit home uid hashedPassword;

    group = "mine";
    extraGroups =
      [
        "adbusers"
        "audio"
        "builders"
        "dialout"
        "fuse"
        "pulse"
        "pulse-access"
        "scanner"
        "users"
        "video"
      ]
      ++ config.soxincfg.users.groups
      ++ (lib.optionals isAdmin ["wheel"] ++ config.soxincfg.users.adminGroups);

    shell = pkgs.zsh;
    isNormalUser = true;

    openssh.authorizedKeys.keys = sshKeys;
  };
in {
  options.soxincfg.users = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable the management of users and groups.
      '';
    };

    users = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        The list of users to create.
      '';
    };

    groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        The list of groups to add all users to.
      '';
    };

    adminGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        The list of groups to add admin users to.
      '';
    };
  };

  config = lib.mkIf config.soxincfg.users.enable (lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      users = {
        mutableUsers = false;

        groups = {
          builders = {gid = 1999;};
          mine = {gid = 1000;};
        };

        users = lib.mapAttrs makeUser config.soxincfg.users.users;
      };
    })
  ]);
}
