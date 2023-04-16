{
  mode,
  lib,
  config,
  ...
}: {
  config = lib.mkMerge [
    {
      soxincfg.users = {
        enable = true;
        users = {
          risson = {
            uid = 1000;
            isAdmin = true;
            home = "/home/risson";
            hashedPassword = "$6$41nyy7f5EIwor$RRn88LX1mgJeqbkAwHWs1cIew7mlJ8lDASKlDYX4OmXgIB7y53CllTPx1KIJ4x/utx9UYBOdzAFkU9zvi2sOw1";
            sshKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL0pnnKrvi9lrliSm+pf9HNAzs0GYLKiJk5AtSg4hhDq risson@yubikey"
            ];
          };
        };
      };
    }

    (lib.optionalAttrs (mode == "NixOS") {
      users.users.root = {
        hashedPassword = "$6$qVi/b8BggEoVLgu$V0Mcqu73FWm3djDT4JwflTgK6iMxgxtFBs2m2R.zg1RukAXIcplI.MddMS5SNEhwAThoKCsFQG7D6Q2pXFohr0";
        openssh.authorizedKeys.keys = config.soxincfg.users.users.risson.sshKeys;
      };

      environment.homeBinInPath = true;
    })
  ];
}
