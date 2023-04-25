{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.self.nixosModules.profiles.workstation
  ];

  nix.gc.automatic = lib.mkForce false;
}
