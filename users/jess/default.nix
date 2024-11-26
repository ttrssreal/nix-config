# NixOS module - entrypoint for HM

{ inputs
, pkgs
, hostname
, util
, ...
}: {
  imports = with inputs; [
    home-manager.nixosModules.home-manager
  ];

  # define the nixos user
  # TODO: put pw in agenix
  users.users.jess = {
    description = "Jess";
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [
      ./id_ed25519.pub
    ];
    shell = pkgs.zsh;
    # we install zsh via hm, so tell
    # nixos to not worry
    ignoreShellProgramCheck = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };


  # TODO: where to put this?
  fonts = {
    packages = with pkgs; [
      font-awesome
      nerdfonts
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      hinting.autohint = true;
    };
  };

  home-manager = {
    backupFileExtension = "orig";
    useGlobalPkgs = true;
    useUserPackages = true;
    # define the hm user (import corr. host definition)
    users.jess =
      import (./. + "/env/${hostname}");
    extraSpecialArgs = {
      inherit inputs util;
      userRoot = ./.;
    };
  };
}
