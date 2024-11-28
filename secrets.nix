# basically scan all the hosts+users for secrets they define and their
# public keys, then smush them all together

# TODO: Rewrite all secret management stuffs :|
# Issue URL: https://github.com/ttrssreal/nix-config/issues/29
#       At least we learnt a bit :3

let
  flake = builtins.getFlake (builtins.toString ./.);

  inherit (flake) inputs nixosConfigurations;
  inherit (inputs.nixpkgs) lib;

  hmConfigurations = lib.concatMapAttrs (_: v:
    v.config.home-manager.users
  ) nixosConfigurations;

  mapSecrets = mapPriv: identities: lib.flatten (lib.mapAttrsToList (n: v:
    if v ? secrets then
      let
        inherit (v.secrets) shared private pubKeyFile;
        pubKey = let pubKeyRaw = builtins.readFile pubKeyFile;
        in lib.trim pubKeyRaw;
      in
        (lib.mapAttrsToList (mapPriv n pubKey) private)
        ++ (lib.mapAttrsToList
          (secretName: _: { "secrets/${secretName}.age" = pubKey; })
          shared
        )
    else []
  ) identities);

  hostSecrets = mapSecrets (hostname: pubKey: secretName: _:
    { "hosts/${hostname}/secrets/${secretName}.age" = pubKey; }
  ) (lib.mapAttrs (_: v: v.config) nixosConfigurations);

  userSecrets = mapSecrets (username: pubKey: secretName: _:
    { "users/${username}/secrets/${secretName}.age" = pubKey; }
  ) hmConfigurations;

  secrets = hostSecrets ++ userSecrets;
in
  builtins.zipAttrsWith
    (name: publicKeys: { inherit publicKeys; })
    secrets
