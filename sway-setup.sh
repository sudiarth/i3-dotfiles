#!/bin/bash
# =============================================================================
# Sway (Wayland) Tiling Window Manager Setup Script for Ubuntu 24.04
# =============================================================================
# Usage: chmod +x sway-setup.sh && ./sway-setup.sh
# After running, log out and select "Sway" from the login screen gear icon.
# =============================================================================

set -e

echo "========================================"
echo "  Sway (Wayland) WM Setup for Ubuntu"
echo "========================================"
echo ""

# =============================================================================
# INSTALL PACKAGES
# =============================================================================

echo "[1/4] Installing packages..."
sudo apt update
sudo apt install -y \
    sway \
    swaylock \
    swayidle \
    waybar \
    wofi \
    mako-notifier \
    grim \
    slurp \
    wl-clipboard \
    playerctl \
    brightnessctl \
    fonts-font-awesome \
    network-manager-gnome \
    pavucontrol \
    libnotify-bin \
    xdg-desktop-portal-wlr \
    xwayland \
    foot

# =============================================================================
# NVIDIA GPU FIX
# =============================================================================

if lspci | grep -qi nvidia && ! lsmod | grep -q nouveau; then
    echo ""
    echo "  Nvidia proprietary driver detected!"
    echo "  Setting up Sway with --unsupported-gpu flag..."

    # Create wrapper script
    mkdir -p ~/.local/bin
    cat > ~/.local/bin/sway-nvidia << 'LAUNCHEREOF'
#!/bin/bash
export WLR_NO_HARDWARE_CURSORS=1
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1
exec sway --unsupported-gpu "$@"
LAUNCHEREOF
    chmod +x ~/.local/bin/sway-nvidia

    # Install system-wide session entry
    sudo cp ~/.local/bin/sway-nvidia /usr/local/bin/sway-nvidia
    sudo tee /usr/share/wayland-sessions/sway-nvidia.desktop > /dev/null << 'SESSIONEOF'
[Desktop Entry]
Name=Sway
Comment=Sway compositor with Nvidia GPU support
Exec=/usr/local/bin/sway-nvidia
Type=Application
DesktopNames=sway
SESSIONEOF
    echo "  Created 'Sway' session entry with Nvidia support."
    echo "  Select 'Sway' from the login screen gear icon."
fi

echo ""
echo "[2/4] Creating config directories..."

# =============================================================================
# CREATE DIRECTORIES
# =============================================================================

mkdir -p ~/.config/sway
mkdir -p ~/.config/waybar
mkdir -p ~/.config/wofi
mkdir -p ~/.config/mako
mkdir -p ~/.config/swaylock

# =============================================================================
# COPY WALLPAPERS
# =============================================================================

echo "[3/4] Copying wallpapers..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$SCRIPT_DIR/wallpapers" ]; then
    mkdir -p ~/.config/sway/wallpapers
    cp "$SCRIPT_DIR"/wallpapers/*.{jpg,png} ~/.config/sway/wallpapers/ 2>/dev/null
    # Set default wallpaper (change this to your preferred one)
    ln -sf ~/.config/sway/wallpapers/anime-city-night.jpg ~/.config/sway/wallpaper.jpg
    echo "  Wallpapers copied to ~/.config/sway/wallpapers/"
    echo "  Default: anime-city-night.jpg"
    echo "  Available:"
    ls -1 "$SCRIPT_DIR"/wallpapers/ 2>/dev/null | sed 's/^/    - /'
    echo "  To change: ln -sf ~/.config/sway/wallpapers/FILENAME ~/.config/sway/wallpaper.jpg"
    echo "             then: swaymsg reload"
fi

# =============================================================================
# SWAY CONFIG
# =============================================================================

echo "[4/4] Writing config files..."

cat > ~/.config/sway/config << 'ENDOFCONFIG'
# Sway config file
# Docs: https://man.archlinux.org/man/sway.5
# i3-compatible syntax with Wayland-native features

# ==============================================================================
# BASICS
# ==============================================================================

# Mod key = Super (Windows key)
set $mod Mod4

# Terminal
set $term foot

# Font for window titles
font pango:DejaVu Sans Mono 10

# Use Mouse+$mod to drag floating windows
floating_modifier $mod normal

# ==============================================================================
# OUTPUT (DISPLAY / WALLPAPER)
# ==============================================================================

# Wallpaper (built-in, no feh needed)
output * bg ~/.config/sway/wallpaper.jpg fill

# Multi-monitor setup (extend, not mirror)
# Laptop display at bottom, external monitor above
# Layout:
#   +------------------+
#   |   HDMI-A-1       |  (external, position 0,0)
#   +------------------+
#   +------------------+
#   |   eDP-1 / eDP    |  (laptop, position 0,<ext_height>)
#   +------------------+
#
# IMPORTANT: Run 'swaymsg -t get_outputs' to find your actual output names
# and adjust the names below if needed. Common names:
#   Laptop:   eDP-1, eDP, eDP-2
#   HDMI:     HDMI-A-1, HDMI-A-0, HDMI-A-2
#   DP:       DP-1, DP-2

# Laptop display
output eDP-1 position 0,1080
output eDP position 0,1080

# External monitor (above laptop)
output HDMI-A-1 position 0,0
output HDMI-A-0 position 0,0
output DP-1 position 0,0
output DP-2 position 0,0

# Assign workspaces to monitors (1-5 external, 6-10 laptop)
workspace 1 output HDMI-A-1 HDMI-A-0 DP-1 DP-2 eDP-1 eDP
workspace 2 output HDMI-A-1 HDMI-A-0 DP-1 DP-2 eDP-1 eDP
workspace 3 output HDMI-A-1 HDMI-A-0 DP-1 DP-2 eDP-1 eDP
workspace 4 output HDMI-A-1 HDMI-A-0 DP-1 DP-2 eDP-1 eDP
workspace 5 output HDMI-A-1 HDMI-A-0 DP-1 DP-2 eDP-1 eDP
workspace 6 output eDP-1 eDP HDMI-A-1 HDMI-A-0 DP-1 DP-2
workspace 7 output eDP-1 eDP HDMI-A-1 HDMI-A-0 DP-1 DP-2
workspace 8 output eDP-1 eDP HDMI-A-1 HDMI-A-0 DP-1 DP-2
workspace 9 output eDP-1 eDP HDMI-A-1 HDMI-A-0 DP-1 DP-2
workspace 10 output eDP-1 eDP HDMI-A-1 HDMI-A-0 DP-1 DP-2

# Quick keybinds to move workspace between monitors
bindsym $mod+p move workspace to output up
bindsym $mod+o move workspace to output down

# Use: swaymsg -t get_outputs  to list monitors

# ==============================================================================
# INPUT (KEYBOARD / TOUCHPAD)
# ==============================================================================

# Keyboard
input type:keyboard {
    xkb_layout us
    repeat_delay 300
    repeat_rate 50
}

# Touchpad (laptop)
input type:touchpad {
    tap enabled
    natural_scroll enabled
    dwt enabled
    middle_emulation enabled
}

# ==============================================================================
# AUTOSTART
# ==============================================================================

# Notifications (mako - Wayland native)
exec mako

# NetworkManager applet (Wayland mode)
exec nm-applet --indicator

# PolicyKit agent (for password prompts)
exec /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 2>/dev/null

# Idle management: lock after 5 min, screen off after 10 min
exec swayidle -w \
    timeout 300 'swaylock -f' \
    timeout 600 'swaymsg "output * power off"' \
    resume 'swaymsg "output * power on"' \
    before-sleep 'swaylock -f'

# Import environment for xdg-desktop-portal (screen sharing, etc.)
exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway

# GTK theme settings
exec_always {
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Yaru'
    gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
    gsettings set org.gnome.desktop.interface font-name 'Ubuntu 11'
}

# ==============================================================================
# KEY BINDINGS - ESSENTIALS
# ==============================================================================

# Launch terminal
bindsym $mod+Return exec $term

# Launch app launcher (wofi)
bindsym $mod+d exec wofi --show drun --style ~/.config/wofi/style.css
bindsym $mod+Tab exec wofi --show window

# Kill focused window
bindsym $mod+Shift+q kill

# Lock screen
bindsym $mod+l exec swaylock -f

# File manager
bindsym $mod+e exec nautilus --new-window

# Reload Sway config
bindsym $mod+Shift+c reload

# Exit Sway
bindsym $mod+Shift+e exec swaynag -t warning -m 'Exit Sway? This will end your session.' -B 'Yes, exit' 'swaymsg exit'

# ==============================================================================
# NAVIGATION
# ==============================================================================

# Change focus (arrow keys)
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# Change focus (vim-style)
bindsym $mod+j focus left
bindsym $mod+k focus down
# Note: $mod+l is used for screen lock
bindsym $mod+semicolon focus right

# Move focused window (arrow keys)
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# Move focused window (vim-style)
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+semicolon move right

# ==============================================================================
# LAYOUT
# ==============================================================================

# Split horizontal / vertical
bindsym $mod+h splith
bindsym $mod+v splitv

# Toggle fullscreen
bindsym $mod+f fullscreen toggle

# Change layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+Shift+t layout toggle split

# Toggle floating
bindsym $mod+Shift+space floating toggle

# Toggle focus between tiling / floating
bindsym $mod+space focus mode_toggle

# Focus parent container
bindsym $mod+a focus parent

# Scratchpad (hidden workspace)
bindsym $mod+Shift+minus move scratchpad
bindsym $mod+minus scratchpad show

# ==============================================================================
# WORKSPACES
# ==============================================================================

set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

# Switch to workspace
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

# Move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

# ==============================================================================
# MEDIA / HARDWARE KEYS
# ==============================================================================

# Volume control
bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle

# Brightness control
bindsym XF86MonBrightnessUp exec brightnessctl set +10%
bindsym XF86MonBrightnessDown exec brightnessctl set 10%-

# Media player controls
bindsym XF86AudioPlay exec playerctl play-pause
bindsym XF86AudioPause exec playerctl play-pause
bindsym XF86AudioNext exec playerctl next
bindsym XF86AudioPrev exec playerctl previous

# Screenshots (grim + slurp - Wayland native)
# Select area -> clipboard
bindsym Print exec grim -g "$(slurp)" - | wl-copy
# Current screen -> clipboard
bindsym $mod+Print exec grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') - | wl-copy
# Full screenshot -> file
bindsym $mod+Shift+Print exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png

# ==============================================================================
# RESIZE MODE
# ==============================================================================

mode "resize" {
    bindsym Left resize shrink width 20px
    bindsym Down resize grow height 20px
    bindsym Up resize shrink height 20px
    bindsym Right resize grow width 20px

    bindsym j resize shrink width 20px
    bindsym k resize grow height 20px
    bindsym l resize shrink height 20px
    bindsym semicolon resize grow width 20px

    # Back to normal
    bindsym Return mode "default"
    bindsym Escape mode "default"
    bindsym $mod+r mode "default"
}

bindsym $mod+r mode "resize"

# ==============================================================================
# APPEARANCE
# ==============================================================================

# Window borders
default_border pixel 2
default_floating_border pixel 2
hide_edge_borders smart

# Gaps
gaps inner 8
gaps outer 2
smart_gaps on

# Colors                    border    bg        text      indicator child_border
client.focused              #6272a4   #6272a4   #f8f8f2   #8be9fd   #6272a4
client.focused_inactive     #44475a   #44475a   #f8f8f2   #44475a   #44475a
client.unfocused            #282a36   #282a36   #bfbfbf   #282a36   #282a36
client.urgent               #ff5555   #ff5555   #f8f8f2   #ff5555   #ff5555
client.placeholder          #282a36   #282a36   #f8f8f2   #282a36   #282a36
client.background           #1a1a2e

# ==============================================================================
# FLOATING RULES
# ==============================================================================

# Sway uses app_id for Wayland apps, class for XWayland apps
for_window [app_id="pavucontrol"] floating enable
for_window [app_id="nm-connection-editor"] floating enable
for_window [app_id="blueman-manager"] floating enable
for_window [app_id="org.gnome.Calculator"] floating enable
for_window [app_id="eog"] floating enable
for_window [app_id="file-roller"] floating enable
for_window [app_id="org.gnome.Nautilus"] floating enable, resize set 900 600
for_window [window_role="pop-up"] floating enable
for_window [window_role="task_dialog"] floating enable

# ==============================================================================
# STATUS BAR (WAYBAR)
# ==============================================================================

bar {
    swaybar_command waybar
}

# XWayland support (for X11 apps like Steam, etc.)
xwayland enable
ENDOFCONFIG

# =============================================================================
# WAYBAR CONFIG
# =============================================================================

cat > ~/.config/waybar/config << 'ENDOFCONFIG'
{
    "layer": "top",
    "position": "top",
    "height": 32,
    "spacing": 8,

    "modules-left": ["sway/workspaces", "sway/mode"],
    "modules-center": ["sway/window"],
    "modules-right": ["network", "cpu", "memory", "disk", "pulseaudio", "backlight", "battery", "clock", "tray"],

    "sway/workspaces": {
        "disable-scroll": false,
        "all-outputs": true,
        "format": "{name}"
    },

    "sway/mode": {
        "format": " {} "
    },

    "sway/window": {
        "max-length": 50
    },

    "clock": {
        "format": "{:%a %b %d  %H:%M}",
        "tooltip-format": "{:%A, %B %d, %Y\n%H:%M:%S}",
        "format-alt": "{:%Y-%m-%d}"
    },

    "cpu": {
        "format": "CPU {usage}%",
        "tooltip": true,
        "interval": 5
    },

    "memory": {
        "format": "Mem {}%",
        "interval": 5
    },

    "disk": {
        "format": "Disk {percentage_used}%",
        "path": "/"
    },

    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "Bat {capacity}%",
        "format-charging": "CHR {capacity}%",
        "format-plugged": "PLG {capacity}%",
        "format-full": "FULL"
    },

    "network": {
        "format-wifi": "W: {essid} {signalStrength}%",
        "format-ethernet": "E: {ipaddr}",
        "format-disconnected": "Offline",
        "tooltip-format": "{ifname}: {ipaddr}/{cidr}\n{bandwidthUpBits} up / {bandwidthDownBits} down"
    },

    "pulseaudio": {
        "format": "Vol {volume}%",
        "format-muted": "Vol MUTE",
        "format-icons": {
            "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
    },

    "backlight": {
        "format": "Br {percent}%"
    },

    "tray": {
        "icon-size": 18,
        "spacing": 8
    }
}
ENDOFCONFIG

cat > ~/.config/waybar/style.css << 'ENDOFCONFIG'
/* Waybar style - Dark theme matching Sway config */

* {
    border: none;
    border-radius: 0;
    font-family: "DejaVu Sans Mono", "Font Awesome 6 Free";
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background-color: #1a1a2e;
    color: #f8f8f2;
}

window#waybar.hidden {
    opacity: 0.2;
}

#workspaces button {
    padding: 0 8px;
    color: #bfbfbf;
    background-color: transparent;
    border-bottom: 2px solid transparent;
}

#workspaces button:hover {
    background: rgba(98, 114, 164, 0.3);
}

#workspaces button.focused {
    color: #f8f8f2;
    background-color: #6272a4;
    border-bottom: 2px solid #8be9fd;
}

#workspaces button.urgent {
    background-color: #ff5555;
    color: #f8f8f2;
}

#mode {
    background-color: #ff5555;
    color: #f8f8f2;
    padding: 0 8px;
    font-weight: bold;
}

#clock,
#battery,
#cpu,
#memory,
#disk,
#backlight,
#network,
#pulseaudio,
#tray {
    padding: 0 10px;
    color: #f8f8f2;
}

#battery.charging {
    color: #50fa7b;
}

#battery.warning:not(.charging) {
    color: #f1fa8c;
}

#battery.critical:not(.charging) {
    color: #ff5555;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: steps(12);
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

@keyframes blink {
    to {
        color: #f8f8f2;
    }
}

#network.disconnected {
    color: #ff5555;
}

#pulseaudio.muted {
    color: #6272a4;
}

tooltip {
    background-color: #282a36;
    border: 1px solid #6272a4;
    border-radius: 8px;
}

tooltip label {
    color: #f8f8f2;
}
ENDOFCONFIG

# =============================================================================
# WOFI CONFIG (APP LAUNCHER)
# =============================================================================

cat > ~/.config/wofi/config << 'ENDOFCONFIG'
show=drun
width=500
height=400
always_parse_args=true
show_all=true
print_command=true
layer=overlay
insensitive=true
prompt=Search...
image_size=24
columns=1
allow_markup=true
ENDOFCONFIG

cat > ~/.config/wofi/style.css << 'ENDOFCONFIG'
/* Wofi style - Dark theme */

window {
    margin: 0;
    border: 2px solid #6272a4;
    border-radius: 8px;
    background-color: #1a1a2eee;
    font-family: "DejaVu Sans";
    font-size: 14px;
}

#input {
    margin: 8px;
    padding: 8px 12px;
    border: none;
    border-radius: 6px;
    color: #f8f8f2;
    background-color: #282a36;
}

#input:focus {
    border: 1px solid #6272a4;
}

#inner-box {
    margin: 0 8px 8px 8px;
}

#outer-box {
    margin: 0;
    padding: 0;
}

#text {
    margin: 0 8px;
    color: #f8f8f2;
}

#entry {
    padding: 6px 8px;
    border-radius: 6px;
}

#entry:selected {
    background-color: #6272a4;
}

#text:selected {
    color: #f8f8f2;
}
ENDOFCONFIG

# =============================================================================
# MAKO CONFIG (NOTIFICATIONS)
# =============================================================================

cat > ~/.config/mako/config << 'ENDOFCONFIG'
# Mako notification daemon config (Wayland native)

font=DejaVu Sans 10
background-color=#1a1a2eee
text-color=#f8f8f2
border-color=#6272a4
border-size=2
border-radius=8
padding=12
margin=10
width=350
height=100
default-timeout=10000
max-visible=3
layer=overlay
anchor=top-right

[urgency=low]
border-color=#44475a
default-timeout=5000

[urgency=normal]
border-color=#6272a4
default-timeout=10000

[urgency=critical]
border-color=#ff5555
default-timeout=0
ENDOFCONFIG

# =============================================================================
# SWAYLOCK CONFIG
# =============================================================================

cat > ~/.config/swaylock/config << 'ENDOFCONFIG'
# Swaylock config

color=1a1a2e
inside-color=1a1a2e
ring-color=6272a4
key-hl-color=8be9fd
line-color=00000000
separator-color=00000000
text-color=f8f8f2

inside-clear-color=1a1a2e
ring-clear-color=f1fa8c
text-clear-color=f8f8f2

inside-ver-color=1a1a2e
ring-ver-color=6272a4
text-ver-color=f8f8f2

inside-wrong-color=1a1a2e
ring-wrong-color=ff5555
text-wrong-color=ff5555

bs-hl-color=ff5555
indicator-radius=80
indicator-thickness=8
font=DejaVu Sans
ENDOFCONFIG

# =============================================================================
# FOOT TERMINAL CONFIG (lightweight Wayland terminal)
# =============================================================================

mkdir -p ~/.config/foot

cat > ~/.config/foot/foot.ini << 'ENDOFCONFIG'
# Foot terminal config (fast Wayland-native terminal)

[main]
font=DejaVu Sans Mono:size=11
pad=8x8

[colors]
background=1a1a2e
foreground=f8f8f2

## Normal colors
regular0=282a36
regular1=ff5555
regular2=50fa7b
regular3=f1fa8c
regular4=6272a4
regular5=ff79c6
regular6=8be9fd
regular7=bfbfbf

## Bright colors
bright0=44475a
bright1=ff6e6e
bright2=69ff94
bright3=ffffa5
bright4=8be9fd
bright5=ff92df
bright6=a4ffff
bright7=f8f8f2

[scrollback]
lines=10000
ENDOFCONFIG

# =============================================================================
# DONE
# =============================================================================

echo ""
echo "========================================"
echo "  Sway setup complete!"
echo "========================================"
echo ""
echo "  Next steps:"
echo "  1. Log out of your current session"
echo "  2. On the login screen, click the gear icon"
echo "  3. Select 'Sway' and log in"
echo ""
echo "  Key bindings (Super = Windows key):"
echo "  Super+Enter        Open terminal (foot)"
echo "  Super+d            App launcher (wofi)"
echo "  Super+Tab          Switch windows"
echo "  Super+Shift+q      Close window"
echo "  Super+l            Lock screen"
echo "  Super+e            File manager"
echo "  Super+1-9          Switch workspace"
echo "  Super+Shift+1-9    Move window to workspace"
echo "  Super+f            Fullscreen"
echo "  Super+h/v          Split horizontal/vertical"
echo "  Super+r            Resize mode (arrows, Esc to exit)"
echo "  Super+Shift+c      Reload config"
echo "  Super+Shift+e      Logout"
echo "  Print Screen       Screenshot area -> clipboard"
echo "  Super+Print        Screenshot screen -> clipboard"
echo "  Super+Shift+Print  Screenshot full -> file"
echo "  Super+minus        Show scratchpad"
echo ""
echo "  Config files:"
echo "  ~/.config/sway/config       Sway WM config"
echo "  ~/.config/waybar/config     Status bar"
echo "  ~/.config/waybar/style.css  Status bar theme"
echo "  ~/.config/wofi/config       App launcher"
echo "  ~/.config/wofi/style.css    App launcher theme"
echo "  ~/.config/mako/config       Notifications"
echo "  ~/.config/swaylock/config   Lock screen"
echo "  ~/.config/foot/foot.ini     Terminal"
echo ""
echo "  Useful commands:"
echo "  swaymsg -t get_outputs      List monitors"
echo "  swaymsg -t get_inputs       List input devices"
echo "  swaymsg reload              Reload config"
echo ""
echo "  Tip: Change wallpaper with:"
echo "    ln -sf ~/.config/sway/wallpapers/FILENAME ~/.config/sway/wallpaper.jpg"
echo "    swaymsg reload"
echo "========================================"
