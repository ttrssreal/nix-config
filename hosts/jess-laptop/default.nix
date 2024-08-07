# Hostname: jess-laptop
# Arch: x86_64-linux
# Notes: :3

{ inputs, config, pkgs, flakeDir, ... }: {
  imports = [
    ./hardware-configuration.nix

    (flakeDir + /users/jess)

    (flakeDir + /hosts/common)

    (flakeDir + /modules/alacritty.nix)
    (flakeDir + /modules/status-bar.nix)
    (flakeDir + /modules/bt-con.nix)
    (flakeDir + /modules/dwm.nix)
    (flakeDir + /modules/podman.nix)
    (flakeDir + /modules/bluetooth.nix)
  ];

  time.timeZone = "Pacific/Auckland";

  # Enable opengl
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  networking = {
    firewall.enable = false;
    hostName = "jess-laptop";
    networkmanager.enable = true;
  };

  # Make gnome apps happy
  programs.dconf.enable = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "psmouse.synaptics_intertouch=0" ];

  security.rtkit.enable = true; # Used for audio

  # Services
  services.thermald.enable = true;
  services.pcscd.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Programs
  programs.slock.enable = true;
  programs.alacritty = {
    enable = true;
    unstable = true;
  };
  programs.dwm = {
    enable = true;
    use-fork = true;
  };

  fonts = {
    packages = [
      pkgs.font-awesome
      pkgs.nerdfonts
    ];
    fontconfig = {
      enable = true;
      hinting.autohint = true;
    };
  };


  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
