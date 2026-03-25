#!/bin/bash
# Brightness control with donut OSD

case "$1" in
    up)   brightnessctl set +5%;;
    down) brightnessctl set 5%-;;
esac

BRIGHT=$(brightnessctl -m | cut -d, -f4 | tr -d '%')

# Kill any existing OSD
pkill -f "python3.*osd.py" 2>/dev/null

python3 ~/.config/i3/osd.py "" "$BRIGHT" &
