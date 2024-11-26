# TODO: Integrate `dwm-status`
# Issue URL: https://github.com/ttrssreal/nix-config/issues/18
#       https://github.com/Gerschtli/dwm-status
#       Fucky when using startx :(
{
  services.dwm-status = {
    enable = true;
    # "audio", "backlight", "battery", "cpu_load", "network", "time"
    order = [
      "network"
      "battery"
      "audio"
      "time"
    ];
  };
}
