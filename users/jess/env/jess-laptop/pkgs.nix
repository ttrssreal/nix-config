{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    xgpro
    vscode
    discord
    # TODO: Manage firefox profiles in nix
    # Issue URL: https://github.com/ttrssreal/nix-config/issues/19
    firefox
    flameshot
    # TODO: Manange obsidian config in nix
    obsidian
    thunderbird
    spotify
    feh
    mpv
    prismlauncher
    openssh
    minikube
    qpwgraph
    font-awesome
    ffmpeg
    cntr
    alsa-utils
    pwndbg
    patchelf
    whois
    burpsuite
    socat
    nerdfonts
    ripgrep
    libclang
    htop
    kubectl
    jq
    ghidra
    obs-studio
    gimp
    p7zip
    inkscape
    jetbrains.idea-ultimate
  ];
}
