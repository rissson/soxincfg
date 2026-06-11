{...}: {
  networking = {
    hostId = "8425e349";
    useDHCP = false;
  };

  systemd.network = {
    enable = true;

    # links = {
    #   "10-lan-mgmt-0" = {
    #     matchConfig = {
    #       MACAddress = "00:e0:4c:50:00:65";
    #     };
    #     linkConfig = {
    #       Name = "lan-mgmt-0";
    #     };
    #   };
    # };

    networks = {
      # "10-lan-mgmt-0" = {
      #   matchConfig = {
      #     Name = "lan-mgmt-0";
      #   };
      #   linkConfig = {
      #     RequiredForOnline = false;
      #   };
      #   networkConfig = {
      #     LinkLocalAddressing = "ipv6";
      #     IPv6AcceptRA = true;
      #   };
      #   address = ["172.28.2.225/27"];
      #   routes = [
      #     {
      #       Destination = "172.28.0.0/15";
      #       Gateway = "172.28.2.254";
      #     }
      #     {
      #       Destination = "209.112.97.0/24";
      #       Gateway = "172.28.2.254";
      #     }
      #   ];
      # };

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
    };
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.enp5s0.ra_defrtr_metric" = 512;
  };
}
