{ config, lib, ... }:

let
  inherit (lib) mkOption types mapAttrsToList;
  emailSources =
    id:
    builtins.filter (x: x != null) [
      id.email
      id.includeFile
      id.secret
    ];
in
{
  options.my = {
    identities = mkOption {
      default = { };
      description = "Named identities available on this host.";
      type = types.attrsOf (
        types.submodule {
          options = {
            fullName = mkOption {
              type = types.str;
              description = ''
                Not secret - it appears in every commit you author anyway.
              '';
            };

            email = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                Plaintext email, committed to this repo. Only for addresses you
                do not mind publishing.
              '';
            };

            includeFile = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "~/.config/git/work-identity";
              description = ''
                Path to a hand-written gitconfig fragment that exists only on
                this machine and is never committed. Git reads it at runtime,
                so the email stays out of the repo without needing sops.

                If the file is missing, git skips it silently and the default
                identity applies instead. Create it before committing there.
              '';
            };

            secret = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "git/work";
              description = ''
                Name of a sops secret holding a gitconfig fragment - the same
                idea as `includeFile`, but encrypted inside the repo.
                Requires sops-nix, which is not set up yet: using this option
                fails evaluation until it is.
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
              description = ''
                Path to the SSH key for this identity. Only the path is stored,
                so it is safe to commit, and it works with any email source.
              '';
            };
          };
        }
      );
    };

    defaultIdentity = mkOption {
      type = types.str;
      description = "Identity used outside any mapped directory.";
    };
  };

  config.assertions = [
    {
      assertion = config.my.identities ? ${config.my.defaultIdentity};
      message = "my.defaultIdentity refers to an identity that is not defined.";
    }
  ]
  ++ mapAttrsToList (n: id: {
    assertion = builtins.length (emailSources id) == 1;
    message = "my.identities.${n}: set exactly one of `email`, `includeFile` or `secret`.";
  }) config.my.identities
  ++ mapAttrsToList (n: id: {
    assertion = id.email != "";
    message = "my.identities.${n}.email is empty. Use `includeFile` to keep an address out of the repo.";
  }) config.my.identities;
}
