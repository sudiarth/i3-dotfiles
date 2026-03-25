#!/bin/bash
# Brightness control with dunst OSD notification

case "$1" in
    up)   brightnessctl set +5%;;
    down) brightnessctl set 5%-;;
esac

BRIGHT=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
dunstify -a "brightness" -u low -r 9998 -h int:value:"$BRIGHT" " $BRIGHT%"
