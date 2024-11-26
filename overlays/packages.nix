{ util
, inputs
, ...
}: util.mkOverlay (final: prev: {
  # TODO: fix
  # Issue URL: https://github.com/ttrssreal/nix-config/issues/12
  # binja = final.callPackage (util.root /pkgs/binaryninja.nix) {};

  bt-con = final.callPackage (util.root /pkgs/bt-con.nix) {};

  status-bar = inputs.status-bar.packages.x86_64-linux.default;

  # woah so this is used by the thingy below bc nix is lazily evaluated!! :3
  inherit (inputs.erosanix.lib.x86_64-linux) mkWindowsApp;
  # Xgpro to use with T56
  xgpro = final.callPackage (util.root /pkgs/xgpro.nix) {};
})
