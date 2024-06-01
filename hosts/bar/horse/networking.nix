{...}: {
  networking = {
    hostId = "8425e349";

    interfaces = {
      enp6s0 = {
        useDHCP = true;
      };
      bar-client = {
        useDHCP = true;
        macAddress = "50:eb:f6:55:9d:18";
      };
    };

    vlans = {
      bar-client = {
        interface = "enp6s0";
        id = 2050;
      };
    };
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.bar-client.ra_defrtr_metric" = 512;
  };
}
