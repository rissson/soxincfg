{
  mode,
  config,
  lib,
  ...
}: let
  yesOrNo = v:
    if v
    then "yes"
    else "no";

  # Configuration comes from
  # https://infosec.mozilla.org/guidelines/openssh

  hostKeyAlgorithms = [
    "ssh-ed25519-cert-v01@openssh.com"
    "ssh-rsa-cert-v01@openssh.com"
    "ssh-ed25519"
    "ssh-rsa"
    "ecdsa-sha2-nistp521-cert-v01@openssh.com"
    "ecdsa-sha2-nistp384-cert-v01@openssh.com"
    "ecdsa-sha2-nistp256-cert-v01@openssh.com"
    "ecdsa-sha2-nistp521"
    "ecdsa-sha2-nistp384"
    "ecdsa-sha2-nistp256"
  ];

  kexAlgorithms = [
    "curve25519-sha256@libssh.org"
    "ecdh-sha2-nistp521"
    "ecdh-sha2-nistp384"
    "ecdh-sha2-nistp256"
    "diffie-hellman-group-exchange-sha256"
  ];

  macs = [
    "hmac-sha2-512-etm@openssh.com"
    "hmac-sha2-256-etm@openssh.com"
    "umac-128-etm@openssh.com"
    "hmac-sha2-512"
    "hmac-sha2-256"
    "umac-128@openssh.com"
  ];

  ciphers = [
    "chacha20-poly1305@openssh.com"
    "aes256-gcm@openssh.com"
    "aes128-gcm@openssh.com"
    "aes256-ctr"
    "aes192-ctr"
    "aes128-ctr"
  ];
in {
  config = lib.mkMerge [
    (lib.optionalAttrs (mode == "NixOS" || mode == "home-manager") {
      programs.ssh = {
        extraConfig = ''
          PubkeyAuthentication yes
          # Ensure KnownHosts are unreadable if leaked - it is otherwise
          # easier to know which hosts your keys have access to.
          HashKnownHosts no
        '';
      };
    })

    (lib.optionalAttrs (mode == "NixOS") {
      programs.ssh = {
        inherit
          hostKeyAlgorithms
          kexAlgorithms
          macs
          ciphers
          ;
      };
    })

    (lib.optionalAttrs (mode == "home-manager") {
      programs.ssh = {
        enable = true;

        controlMaster = "auto";
        controlPersist = "1m";

        matchBlocks = {
          ### Lama Corp.
          "nucleus" = {
            user = "root";
            hostname = "nucleus.fsn.lama.tel";
          };
          "*.lama.tel" = {
            user = "root";
            proxyJump = "nucleus";
          };

          ### Git hosting
          "gitlab" = {
            hostname = "gitlab.com";
            user = "git";
          };
          "github" = {
            hostname = "github.com";
            user = "git";
          };
        };

        extraConfig = ''
          # Host keys the client accepts - order here is honored by OpenSSH
          ${lib.optionalString (hostKeyAlgorithms != [])
            ("HostKeyAlgorithms " + (lib.concatStringsSep "," hostKeyAlgorithms))}

          ${lib.optionalString (kexAlgorithms != [])
            ("KexAlgorithms " + (lib.concatStringsSep "," kexAlgorithms))}
          ${lib.optionalString (macs != [])
            ("MACs " + (lib.concatStringsSep "," macs))}
          ${lib.optionalString (ciphers != [])
            ("Ciphers " + (lib.concatStringsSep "," ciphers))}
        '';
      };
    })
  ];
}
