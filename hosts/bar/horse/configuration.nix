{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.self.nixosModules.profiles.workstation
    inputs.self.nixosModules.profiles.zfs

    ./hardware-configuration.nix
    ./networking.nix
  ];

  nix.gc.automatic = lib.mkForce false;

  services.xserver.videoDrivers = lib.mkBefore ["nvidia" "nouveau"];
}
