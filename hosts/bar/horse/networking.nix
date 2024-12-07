{...}: {
  networking = {
    hostId = "8425e349";

    interfaces = {
      enp5s0 = {
        ipv4 = {
          addresses = [
            {
              address = "172.28.2.100";
              prefixLength = 24;
            }
          ];
          routes = [
            {
              address = "172.28.0.0";
              prefixLength = 15;
              via = "172.28.2.254";
            }
          ];
        };
      };
      bar-client = {
        ipv4 = {
          addresses = [
            {
              address = "172.29.2.100";
              prefixLength = 24;
            }
          ];
        };
        useDHCP = true;
        macAddress = "50:eb:f6:55:9d:18";
      };
    };

    vlans = {
      bar-client = {
        interface = "enp5s0";
        id = 2050;
      };
    };
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.bar-client.ra_defrtr_metric" = 512;
  };
}
