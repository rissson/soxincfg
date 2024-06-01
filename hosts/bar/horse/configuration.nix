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
    ./gpu2.nix
  ];

  nix.gc.automatic = lib.mkForce false;

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [polkit_gnome];

  # services.netdata.enable = true;

  # services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  environment.etc."eos/fuse.eos.conf".text = ''
    {
      "name": "eos",
      "hostport": "mgm.services-eos.svc.c.k3s.fsn.lama.tel",
      "remotemountdir": "/eos",
      "localmountdir": "/eos",
      "auth": {
        "shared-mount": 1,
        "sss": 0,
        "gsi-first": 0,
        "krb5": 1,
        "oauth2": 0,
        "ignore-containerization": 1
      },
      "options": {
        "hide-versions": 0
      }
    }
  '';

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      eos-fusex = {
        image = "gitlab-registry.cern.ch/dss/eos/eos-ci:5.2.22";
        entrypoint = "/usr/bin/eosxd3";
        cmd = ["-f" "-ofsname=eos"];
        environment = {
          EOS_MGM_URL = "root://mgm.services-eos.svc.c.k3s.fsn.lama.tel";
          XRD_NODELAY = "1";
        };
        extraOptions = [
          "--volume=/etc/krb5.conf:/etc/krb5.conf:ro"
          "--mount=type=bind,source=/eos,target=/eos,bind-propagation=shared"
          "--volume=/etc/eos/fuse.eos.conf:/etc/eos/fuse.eos.conf:ro"
          "--volume=/var/cache/eos:/var/cache/eos"
          "--volume=/dev/fuse:/dev/fuse"
          "--privileged"
          "--network=host"
          "--pid=host"
          "--uts=host"
          "--ipc=host"
        ];
      };
    };
  };

  services.gpsd = {
    enable = true;
    devices = [
      "/dev/ttyACM1"
      "ntrip://caster.centipede.fr:2101/WLBH"
    ];
  };
}
