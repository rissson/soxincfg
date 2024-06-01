{...}: {
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];
  boot.kernelParams = [
    "amd_iommu=on"
    "vfio-pci.ids=10de:1f08,10de:10f9,10de:1ada,10de:1adb"
  ];
}
