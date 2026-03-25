#!/bin/bash
# =============================================================================
# i3 Desktop Setup - Single Install Script
# =============================================================================
# Sets up i3 with Dracula theme, rofi, wallpapers, multi-monitor, GTK themes
#
# Usage:
#   chmod +x install.sh
#   sudo ./install.sh
#
# After install, restart i3 with Mod+Shift+r
# =============================================================================

set -e

# Must run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo: sudo ./install.sh"
    exit 1
fi

# Get the actual user (not root)
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Installing packages ==="
apt update
apt install -y \
    i3 \
    i3status \
    i3lock \
    rofi \
    feh \
    lxappearance \
    pavucontrol \
    arandr \
    nm-applet \
    fonts-font-awesome \
    blueman \
    arc-theme \
    breeze-gtk-theme \
    numix-gtk-theme \
    materia-gtk-theme \
    greybird-gtk-theme \
    papirus-icon-theme \
    numix-icon-theme \
    breeze-icon-theme \
    breeze-cursor-theme

echo ""
echo "=== Setting up i3 config ==="
mkdir -p "$REAL_HOME/.config/i3"
cp "$SCRIPT_DIR/i3-config" "$REAL_HOME/.config/i3/config"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/i3/config"

echo "=== Setting up GTK theme ==="
mkdir -p "$REAL_HOME/.config/gtk-3.0"
cp "$SCRIPT_DIR/gtk.css" "$REAL_HOME/.config/gtk-3.0/gtk.css"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/gtk-3.0/gtk.css"

echo "=== Copying wallpapers ==="
mkdir -p "$REAL_HOME/Pictures/wallpapers"
cp "$SCRIPT_DIR/wallpapers/"* "$REAL_HOME/Pictures/wallpapers/"
chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/Pictures/wallpapers"

echo "=== Applying GTK settings ==="
sudo -u "$REAL_USER" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u $REAL_USER)/bus" \
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null || true
sudo -u "$REAL_USER" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u $REAL_USER)/bus" \
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

echo ""
echo "========================================="
echo "  Setup complete!"
echo "========================================="
echo ""
echo "  Restart i3: Mod+Shift+r"
echo "  App launcher: Mod+Space or Mod+d"
echo "  Settings:"
echo "    Appearance:  lxappearance"
echo "    Sound:       pavucontrol"
echo "    Display:     arandr"
echo "    Network:     nm-connection-editor"
echo "    Bluetooth:   blueman-manager"
echo ""
