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
    ./gpu.nix
    ./boot.nix
  ];

  nix.gc.automatic = lib.mkForce false;

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [polkit_gnome];

  services.netdata.enable = true;
}
