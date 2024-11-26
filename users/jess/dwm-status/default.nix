# TODO: Integrate `dwm-status`
#       https://github.com/Gerschtli/dwm-status
#       Currently broken here
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
