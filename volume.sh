#!/bin/bash
# Volume control with dunst OSD notification

case "$1" in
    up)   pactl set-sink-volume @DEFAULT_SINK@ +5%;;
    down) pactl set-sink-volume @DEFAULT_SINK@ -5%;;
    mute) pactl set-sink-mute @DEFAULT_SINK@ toggle;;
esac

MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -c "yes")
VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

if [ "$MUTED" -eq 1 ]; then
    dunstify -a "volume" -u low -r 9999 -h int:value:0 " Muted"
else
    dunstify -a "volume" -u low -r 9999 -h int:value:"$VOL" " $VOL%"
fi

killall -SIGUSR1 i3status
