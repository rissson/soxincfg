{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      services.openafsClient = {
        enable = true;
        cellName = "lama-corp.space";
        cache = {
          diskless = true;
        };
        fakestat = true;
      };
    })
  ];
}
