{ pkgs
, lib
, ...
}: {
  home.file.".xinitrc".text = ''
    # fix java grey screen issue
    export _JAVA_AWT_WM_NONREPARENTING=1

    picom & # compositor
    feh --bg-max --randomize ${./wallpaper}/* & # wallpaper

    LOG_FILE="/tmp/program_starter.log"

    is_running() {
        pgrep "status_bar" >/dev/null
    }

    export DISPLAY=":0";
    export WIFI_DEVICE_NAME="wlp0s20f3";
    export BATTERY_CAPACITY_DEVICE="/sys/class/power_supply/BAT0/capacity";
    export BATTERY_STATUS_DEVICE="/sys/class/power_supply/BAT0/status";
    export TIME_UPDATE_PERIOD="1000";
    export VOLUME_UPDATE_PERIOD="50";
    export BATTERY_UPDATE_PERIOD="2000";
    export WIFI_UPDATE_PERIOD="2000";

    while true; do
        if ! is_running; then
            echo "$(date): status_bar is not running. Attempting to start..." >> "$LOG_FILE"
            ${lib.getExe pkgs.status-bar} &
        else
            echo "$(date): status_bar is already running." >> "$LOG_FILE"
            break
        fi
        sleep 1
    done &

    echo $! > /tmp/program_starter.pid

    exec dwm # window manager
  '';
}
