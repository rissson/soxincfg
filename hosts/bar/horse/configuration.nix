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
  ];

  nix.gc.automatic = lib.mkForce false;

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [polkit_gnome];

  # services.netdata.enable = true;

  # services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  networking.extraHosts = "127.0.0.1 dev.authentik.company";
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.nameservers = ["172.29.2.254" "172.28.2.254"];
  networking.dhcpcd.extraConfig = ''
    nohook resolv.conf
  '';
}
