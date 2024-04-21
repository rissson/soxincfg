{
  mode,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS") {
      krb5 = {
        enable = true;
        libdefaults = {
          default_realm = "LAMA-CORP.SPACE";
          dns_fallback = true;
          dns_canonicalize_hostname = false;
          rnds = false;
          default_ccache_name = "KEYRING:persistent:%{uid}";
        };

        realms = {
          "LAMA-CORP.SPACE" = {
            admin_server = "kerberos.lama-corp.space";
          };
        };
      };
    })
  ];
}
