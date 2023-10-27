{...}: {
  networking = {
    interfaces = {
      eno1 = {
        useDHCP = true;
      };
    };
  };
}
