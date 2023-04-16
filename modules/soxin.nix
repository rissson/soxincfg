{...}: {
  soxin = {
    hardware = {
      bluetooth.enable = true;
    };

    programs = {
      less = {
        enable = true;
        keyboardLayout = {console.keyMap = "us";};
      };

      rofi.enable = true;
    };
  };
}
