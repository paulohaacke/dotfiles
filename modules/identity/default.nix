{ config, lib, ... }:

let
  inherit (lib) mkOption types mapAttrsToList;
in
{
  options.my = {
    identities = mkOption {
      default = { };
      description = "Named identities available on this host.";
      type = types.attrsOf (types.submodule {
        options = {
          fullName = mkOption {
            type = types.str;
            description = ''
              Not secret - it appears in every commit you author anyway.
              Kept in plaintext so the host file stays readable.
            '';
          };

          email = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Plaintext email, for identities you do not mind committing.
              Mutually exclusive with `secret`.
            '';
          };

          secret = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "git/work";
            description = ''
              Name of a sops secret holding a gitconfig fragment for this
              identity. The fragment is read by git at runtime, so its
              contents never enter Nix evaluation.

              Put `[user] email` and any `[core] sshCommand` inside the
              encrypted fragment - the `sshKey` option below is only for
              plaintext identities.

              Mutually exclusive with `email`.
            '';
          };

          directory = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "~/work/";
            description = ''
              Directory prefix selecting this identity. Repos underneath it
              use it automatically. Null for the default identity.
              The trailing slash is required.
            '';
          };

          sshKey = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Only for plaintext identities; see `secret`.";
          };
        };
      });
    };

    defaultIdentity = mkOption {
      type = types.str;
      description = "Identity used outside any mapped directory.";
    };
  };

  config.assertions =
    [{
      assertion = config.my.identities ? ${config.my.defaultIdentity};
      message = "my.defaultIdentity refers to an identity that is not defined.";
    }]
    ++ mapAttrsToList (n: id: {
      # XOR: exactly one of the two forms.
      assertion = (id.email == null) != (id.secret == null);
      message = "my.identities.${n}: set exactly one of `email` or `secret`.";
    }) config.my.identities;
}
