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
          LinkLocalAddressing = "ipv6";
          IPv6AcceptRA = true;
        };
      };
      "10-lan-mgmt-0" = {
        matchConfig.Name = "lan-mgmt-0";
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          LinkLocalAddressing = "ipv6";
          IPv6AcceptRA = true;
        };
        address = ["172.28.2.225/27"];
        routes = [
          {
            Destination = "172.28.0.0/16";
            Gateway = "172.28.2.254";
          }
          {
            Destination = "172.29.0.0/16";
            Gateway = "172.28.2.254";
          }
          {
            Destination = "209.112.97.0/24";
            Gateway = "172.28.2.254";
          }
        ];
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
