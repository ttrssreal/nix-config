{ util
, lib
, userRoot
, ...
}: {
  imports = lib.flatten [
    (userRoot + /base.nix)
    # TODO: server: (hacky+broken) using jess-laptop stuffs
    # TODO: server: (hacky+broken) using jess-laptop stuffs
    #       xinit starts status bar with battery info
    #       but we dont have a battery D:
    ../jess-laptop/pkgs.nix
    ../jess-laptop/xinit.nix

    (util.pathsFrom userRoot [
      # /dwm-status
      /alacritty
      # /direnv
      /gpg
      /nix
      /zsh
      /jessvim
    ])

    (util.hmModules [
      # /bt-con
      /picom
      # /secrets
    ])
  ];

  jess.git.forceGithubSSH = false;
  programs.alacritty.settings.font.size = lib.mkForce 11;

  home.homeDirectory = "/home/jess";
}
