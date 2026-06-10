{...}: {
  networking = {
    hostId = "8425e349";
    useDHCP = false;
    firewall.checkReversePath = "loose";
  };

  systemd.network = {
    enable = true;

    links = {
      "10-cl-home-2050" = {
        matchConfig.MACAddress = "10:ff:e0:bc:fb:53";
        linkConfig.Name = "cl-home-2050";
      };
      "10-lan-mgmt-0" = {
        matchConfig.MACAddress = "00:e0:4c:50:00:65";
        linkConfig.Name = "lan-mgmt-0";
      };
    };

    networks = {
      "10-cl-home-2050" = {
        matchConfig.Name = "cl-home-2050";
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = true;
        };
      };
      "10-lan-mgmt-0" = {
        matchConfig.Name = "lan-mgmt-0";
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = true;
        };
      };
    };
  };

  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        Cache = false;
      };
    };
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.cl-home-2050.ra_defrtr_metric" = 512;
  };
}
