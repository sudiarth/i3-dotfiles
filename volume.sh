#!/bin/bash
# Volume control with donut OSD

case "$1" in
    up)   pactl set-sink-volume @DEFAULT_SINK@ +5%;;
    down) pactl set-sink-volume @DEFAULT_SINK@ -5%;;
    mute) pactl set-sink-mute @DEFAULT_SINK@ toggle;;
esac

MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -c "yes")
VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

# Kill any existing OSD
pkill -f "python3.*osd.py" 2>/dev/null

if [ "$MUTED" -eq 1 ]; then
    python3 ~/.config/i3/osd.py "" 0 "Muted" &
else
    python3 ~/.config/i3/osd.py "" "$VOL" &
fi

killall -SIGUSR1 i3status
