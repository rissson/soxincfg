{
  mode,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      hardware.keyboard.zsa.enable = true;
      environment.systemPackages = with pkgs; [wally-cli];
    })
  ];
}
