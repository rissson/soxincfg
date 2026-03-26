{...}: {
  networking = {
    hostId = "8425e349";
    useDHCP = false;
  };

  systemd.network = {
    enable = true;

    links = {
      "10-bar-client" = {
        matchConfig.Name = "enp5s0";
      };
    };

    netdevs = {
      "20-bar-mgmt" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "bar-mgmt";
        };
        vlanConfig.Id = 1;
      };
    };

    networks = {
      "10-bar-client" = {
        matchConfig.Name = "enp5s0";
        vlan = [
          "bar-mgmt"
        ];
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "20-bar-mgmt" = {
        matchConfig.Name = "bar-mgmt";
        address = ["172.28.2.225/27"];
        routes = [
          {
            Destination = "172.28.0.0/15";
            Gateway = "172.28.2.254";
          }
          {
            Destination = "209.112.97.0/24";
            Gateway = "172.28.2.254";
          }
        ];
        networkConfig = {
          IPv6AcceptRA = true;
        };
      };
    };
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.enp5s0.ra_defrtr_metric" = 512;
  };
}
