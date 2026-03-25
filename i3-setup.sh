#!/bin/bash
# =============================================================================
# i3 Window Manager Setup Script for Ubuntu 24.04
# =============================================================================
# Usage: chmod +x i3-setup.sh && ./i3-setup.sh
# After running, log out and select "i3" from the login screen gear icon.
# =============================================================================

set -e

echo "========================================"
echo "  i3 Window Manager Setup for Ubuntu"
echo "========================================"
echo ""

# =============================================================================
# INSTALL PACKAGES
# =============================================================================

echo "[1/3] Installing packages..."
sudo apt update
sudo apt install -y \
    i3 \
    i3status \
    i3lock \
    rofi \
    picom \
    dunst \
    feh \
    flameshot \
    playerctl \
    brightnessctl \
    xclip \
    lxappearance \
    network-manager-gnome \
    pavucontrol \
    arandr \
    fonts-font-awesome

echo ""
echo "[2/3] Creating config directories..."

# =============================================================================
# CREATE DIRECTORIES
# =============================================================================

mkdir -p ~/.config/i3
mkdir -p ~/.config/i3status
mkdir -p ~/.config/rofi
mkdir -p ~/.config/picom
mkdir -p ~/.config/dunst

# =============================================================================
# i3 CONFIG
# =============================================================================

echo "[3/3] Writing config files..."

cat > ~/.config/i3/config << 'ENDOFCONFIG'
# i3 config file (v4)
# Docs: https://i3wm.org/docs/userguide.html

# ==============================================================================
# BASICS
# ==============================================================================

# Mod key = Super (Windows key)
set $mod Mod4

# Font for window titles and bar
font pango:DejaVu Sans Mono, Font Awesome 6 Free 10

# Use Mouse+$mod to drag floating windows
floating_modifier $mod

# ==============================================================================
# AUTOSTART
# ==============================================================================

# Compositor (smooth rendering, no tearing)
exec_always --no-startup-id picom --config ~/.config/picom/picom.conf

# Notifications
exec --no-startup-id dunst

# NetworkManager applet (system tray)
exec --no-startup-id nm-applet

# Set wallpaper
exec_always --no-startup-id feh --bg-fill ~/.config/i3/wallpaper.jpg 2>/dev/null || feh --bg-scale /usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png 2>/dev/null

# Restore GNOME settings (cursor, fonts, themes)
exec --no-startup-id xrdb -merge ~/.Xresources 2>/dev/null
exec --no-startup-id xset r rate 300 50

# PolicyKit agent (for password prompts when installing software, etc.)
exec --no-startup-id /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 2>/dev/null

# ==============================================================================
# KEY BINDINGS - ESSENTIALS
# ==============================================================================

# Launch terminal
bindsym $mod+Return exec i3-sensible-terminal

# Launch app launcher (rofi)
bindsym $mod+d exec --no-startup-id rofi -show drun -show-icons
bindsym $mod+Tab exec --no-startup-id rofi -show window -show-icons

# Kill focused window
bindsym $mod+Shift+q kill

# Lock screen
bindsym $mod+l exec --no-startup-id i3lock -c 1a1a2e -e -f

# File manager
bindsym $mod+e exec --no-startup-id nautilus --new-window

# Reload i3 config
bindsym $mod+Shift+c reload

# Restart i3 in-place (preserves layout)
bindsym $mod+Shift+r restart

# Exit i3 (logout)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'Exit i3? This will end your session.' -B 'Yes, exit' 'i3-msg exit'"

# ==============================================================================
# NAVIGATION
# ==============================================================================

# Change focus (arrow keys)
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# Change focus (vim-style: j/k/l/semicolon)
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
bindsym $mod+h split h
bindsym $mod+v split v

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

# ==============================================================================
# WORKSPACES
# ==============================================================================

# Workspace names
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
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle

# Brightness control
bindsym XF86MonBrightnessUp exec --no-startup-id brightnessctl set +10%
bindsym XF86MonBrightnessDown exec --no-startup-id brightnessctl set 10%-

# Media player controls
bindsym XF86AudioPlay exec --no-startup-id playerctl play-pause
bindsym XF86AudioPause exec --no-startup-id playerctl play-pause
bindsym XF86AudioNext exec --no-startup-id playerctl next
bindsym XF86AudioPrev exec --no-startup-id playerctl previous

# Screenshots
bindsym Print exec --no-startup-id flameshot gui
bindsym $mod+Print exec --no-startup-id flameshot screen -c
bindsym $mod+Shift+Print exec --no-startup-id flameshot full -c

# ==============================================================================
# RESIZE MODE
# ==============================================================================

mode "resize" {
    bindsym Left resize shrink width 5 px or 5 ppt
    bindsym Down resize grow height 5 px or 5 ppt
    bindsym Up resize shrink height 5 px or 5 ppt
    bindsym Right resize grow width 5 px or 5 ppt

    bindsym j resize shrink width 5 px or 5 ppt
    bindsym k resize grow height 5 px or 5 ppt
    bindsym l resize shrink height 5 px or 5 ppt
    bindsym semicolon resize grow width 5 px or 5 ppt

    # Back to normal: Enter or Escape or $mod+r
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

# Gaps (i3-gaps feature, included in i3 on Ubuntu 24.04)
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

# Apps that should float by default
for_window [class="Pavucontrol"] floating enable
for_window [class="Arandr"] floating enable
for_window [class="Nm-connection-editor"] floating enable
for_window [class="Blueman-manager"] floating enable
for_window [class="Gnome-calculator"] floating enable
for_window [class="Eog"] floating enable
for_window [class="File-roller"] floating enable
for_window [window_role="pop-up"] floating enable
for_window [window_role="task_dialog"] floating enable
for_window [title="Volume Control"] floating enable

# ==============================================================================
# STATUS BAR
# ==============================================================================

bar {
    status_command i3status --config ~/.config/i3status/config
    position top
    tray_output primary
    separator_symbol " | "

    colors {
        background #1a1a2e
        statusline #f8f8f2
        separator  #6272a4

        #                  border    bg        text
        focused_workspace  #6272a4   #6272a4   #f8f8f2
        active_workspace   #44475a   #44475a   #f8f8f2
        inactive_workspace #1a1a2e   #1a1a2e   #bfbfbf
        urgent_workspace   #ff5555   #ff5555   #f8f8f2
    }
}
ENDOFCONFIG

# =============================================================================
# i3STATUS CONFIG
# =============================================================================

cat > ~/.config/i3status/config << 'ENDOFCONFIG'
# i3status configuration
# Docs: https://i3wm.org/docs/i3status.html

general {
    colors = true
    color_good = "#50fa7b"
    color_degraded = "#f1fa8c"
    color_bad = "#ff5555"
    interval = 5
    output_format = "i3bar"
}

order += "wireless _first_"
order += "ethernet _first_"
order += "disk /"
order += "cpu_usage"
order += "memory"
order += "volume master"
order += "battery all"
order += "tztime local"

wireless _first_ {
    format_up = "W: %essid %quality"
    format_down = "W: down"
}

ethernet _first_ {
    format_up = "E: %ip"
    format_down = ""
}

disk "/" {
    format = "Disk: %avail"
    low_threshold = 10
    threshold_type = "percentage_avail"
}

cpu_usage {
    format = "CPU: %usage"
    max_threshold = 90
    degraded_threshold = 70
}

memory {
    format = "Mem: %used/%total"
    threshold_degraded = "1G"
    threshold_critical = "200M"
}

volume master {
    format = "Vol: %volume"
    format_muted = "Vol: muted"
    device = "default"
    mixer = "Master"
    mixer_idx = 0
}

battery all {
    format = "Bat: %status %percentage %remaining"
    format_down = ""
    status_chr = "CHR"
    status_bat = "BAT"
    status_unk = "UNK"
    status_full = "FULL"
    low_threshold = 20
    threshold_type = "percentage"
    last_full_capacity = true
}

tztime local {
    format = "%a %b %d  %H:%M"
}
ENDOFCONFIG

# =============================================================================
# ROFI CONFIG
# =============================================================================

cat > ~/.config/rofi/config.rasi << 'ENDOFCONFIG'
/* Rofi config - Dark theme */

configuration {
    modi: "drun,window,run";
    show-icons: true;
    icon-theme: "Yaru";
    display-drun: "Apps";
    display-window: "Windows";
    display-run: "Run";
    drun-display-format: "{name}";
    font: "DejaVu Sans 12";
}

* {
    bg:       #1a1a2eee;
    bg-alt:   #282a36;
    fg:       #f8f8f2;
    fg-alt:   #6272a4;
    accent:   #6272a4;
    urgent:   #ff5555;

    background-color: @bg;
    text-color:       @fg;
    margin:  0;
    padding: 0;
    spacing: 0;
}

window {
    width:          500px;
    border:         2px;
    border-color:   @accent;
    border-radius:  8px;
}

inputbar {
    padding:    12px;
    spacing:    8px;
    children:   [ prompt, entry ];
}

prompt {
    text-color: @accent;
}

entry {
    placeholder:        "Search...";
    placeholder-color:  @fg-alt;
}

message {
    border: 1px 0 0;
    border-color: @fg-alt;
    padding: 8px;
}

listview {
    lines:      8;
    columns:    1;
    fixed-height: true;
    border: 1px 0 0;
    border-color: @fg-alt;
}

element {
    padding: 8px 12px;
    spacing: 8px;
}

element selected normal {
    background-color: @accent;
    text-color:       @fg;
}

element selected urgent {
    background-color: @urgent;
}

element-icon {
    size: 24px;
    vertical-align: 0.5;
}

element-text {
    vertical-align: 0.5;
}
ENDOFCONFIG

# =============================================================================
# PICOM CONFIG
# =============================================================================

cat > ~/.config/picom/picom.conf << 'ENDOFCONFIG'
# Picom compositor config
# Provides smooth rendering and prevents screen tearing

# Backend
backend = "glx";
vsync = true;
glx-no-stencil = true;

# Shadows
shadow = true;
shadow-radius = 12;
shadow-opacity = 0.5;
shadow-offset-x = -5;
shadow-offset-y = -5;

shadow-exclude = [
    "name = 'Notification'",
    "class_g = 'i3-frame'",
    "class_g = 'Conky'",
    "_GTK_FRAME_EXTENTS@:c",
    "class_g = 'firefox' && argb"
];

# Fading
fading = true;
fade-in-step = 0.07;
fade-out-step = 0.07;
fade-delta = 5;

# Opacity
inactive-opacity = 0.95;
active-opacity = 1.0;
frame-opacity = 1.0;
inactive-opacity-override = false;

focus-exclude = [
    "class_g = 'firefox'",
    "class_g = 'mpv'",
    "class_g = 'vlc'"
];

# Corners
corner-radius = 6;

# Misc
mark-wmwin-focused = true;
mark-ovredir-focused = true;
detect-rounded-corners = true;
detect-client-opacity = true;
detect-transient = true;
use-damage = true;
log-level = "warn";
ENDOFCONFIG

# =============================================================================
# DUNST CONFIG
# =============================================================================

cat > ~/.config/dunst/dunstrc << 'ENDOFCONFIG'
[global]
    # Display
    monitor = 0
    follow = mouse

    # Geometry
    width = 350
    height = 100
    origin = top-right
    offset = 10x40

    # Progress bar
    progress_bar = true
    progress_bar_height = 10

    # Appearance
    transparency = 10
    separator_height = 2
    padding = 12
    horizontal_padding = 12
    text_icon_padding = 12
    frame_width = 2
    frame_color = "#6272a4"
    separator_color = frame
    corner_radius = 8

    # Text
    font = DejaVu Sans 10
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    vertical_alignment = center
    show_age_threshold = 60
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes

    # Icons
    icon_position = left
    min_icon_size = 32
    max_icon_size = 64

    # History
    sticky_history = yes
    history_length = 20

    # Misc
    browser = /usr/bin/xdg-open
    always_run_script = true
    mouse_left_click = close_current
    mouse_middle_click = do_action, close_current
    mouse_right_click = close_all

[urgency_low]
    background = "#1a1a2e"
    foreground = "#f8f8f2"
    frame_color = "#44475a"
    timeout = 5

[urgency_normal]
    background = "#1a1a2e"
    foreground = "#f8f8f2"
    frame_color = "#6272a4"
    timeout = 10

[urgency_critical]
    background = "#1a1a2e"
    foreground = "#f8f8f2"
    frame_color = "#ff5555"
    timeout = 0
ENDOFCONFIG

# =============================================================================
# DONE
# =============================================================================

echo ""
echo "========================================"
echo "  Setup complete!"
echo "========================================"
echo ""
echo "  Next steps:"
echo "  1. Log out of your current session"
echo "  2. On the login screen, click the gear icon"
echo "  3. Select 'i3' and log in"
echo ""
echo "  Key bindings (Super = Windows key):"
echo "  Super+Enter        Open terminal"
echo "  Super+d            App launcher (rofi)"
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
echo "  Print Screen       Screenshot (select area)"
echo ""
echo "  Config files:"
echo "  ~/.config/i3/config"
echo "  ~/.config/i3status/config"
echo "  ~/.config/rofi/config.rasi"
echo "  ~/.config/picom/picom.conf"
echo "  ~/.config/dunst/dunstrc"
echo ""
echo "  Tip: Place a wallpaper at ~/.config/i3/wallpaper.jpg"
echo "  Tip: Run 'lxappearance' to change GTK themes/fonts"
echo "  Tip: Run 'arandr' to configure monitor layout"
echo "========================================"
