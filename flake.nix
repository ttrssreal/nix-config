{
  description = "nix configs for my hosts :3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    home-manager = {
      url = "github:ttrssreal/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    # TODO: Retire custom status bar
    # Issue URL: https://github.com/ttrssreal/nix-config/issues/11
    status-bar.url = "github:ttrssreal/status-bar";
    erosanix.url = "github:emmanuelrosa/erosanix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs @ { self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;

      util = import ./util.nix { inherit util lib inputs; };

      jess = ./users/jess;
    in {
      devShells = util.mkDevShells nixpkgs [
        "x86_64-linux"
      ];

      nixosConfigurations = {
        jess-laptop = util.mkHost "jess-laptop" [
          jess
        ];

        ari = util.mkHost "ari" [
          jess
        ];

        server = util.mkHost "server" [
          jess
        ];
      };

      homeConfigurations = let
        mkNixosUsers = hostname: def: lib.concatMapAttrs
          (util.mkUserAtHost hostname def)
          def.config.home-manager.users;
      in
        lib.concatMapAttrs mkNixosUsers self.nixosConfigurations;

      templates = import ./templates;
    };
}
