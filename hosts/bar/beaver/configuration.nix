{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.self.nixosModules.profiles.workstation

    ./hardware-configuration.nix
    ./networking.nix
  ];

  nix.gc.automatic = lib.mkForce false;

  services.xserver.displayManager.autoLogin.enable = lib.mkForce false;
}
