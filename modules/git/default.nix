{ config, lib, ... }:

let
  inherit (lib) filterAttrs concatMap attrValues optionals;

  ids = config.my.identities;
  defaultId = ids.${config.my.defaultIdentity};

  secretPath = name: config.sops.secrets.${name}.path;

  mkIncludes = id: condition:
    let cond = if condition == null then { } else { inherit condition; };
    in
      optionals (id.secret != null)
        [ (cond // { path = secretPath id.secret; }) ]
      ++ optionals (id.email != null)
        [ (cond // { contents.user = { name = id.fullName; email = id.email; }; }) ]
      ++ optionals (id.sshKey != null)
        [ (cond // { contents.core.sshCommand = "ssh -i ${id.sshKey}"; }) ];

  scoped = attrValues (filterAttrs (_: id: id.directory != null) ids);
in
{
  programs.git = {
    enable = true;

    settings.user = {
      name = defaultId.fullName;
      useConfigOnly = true;
    };

    includes =
      mkIncludes defaultId null
      ++ concatMap (id: mkIncludes id "gitdir:${id.directory}") scoped;
  };
}
