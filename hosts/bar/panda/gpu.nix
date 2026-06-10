{
  pkgs,
  lib,
  ...
}: {
  services.xserver.videoDrivers = lib.mkForce ["amdgpu"];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
}
