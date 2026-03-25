#!/bin/bash
# =============================================================================
# i3 Desktop Setup - Single Install Script
# =============================================================================
# Sets up i3 with Nord theme, rofi, i3status, wallpapers, multi-monitor,
# GTK themes, power menu, picom compositor, and useful tools.
#
# Usage:
#   git clone https://github.com/sudiarth/i3-dotfiles
#   cd i3-dotfiles
#   sudo ./install.sh
#
# After install, log out and log back in to i3.
# =============================================================================

set -e

if [ "$EUID" -ne 0 ]; then
    echo "Please run with sudo: sudo ./install.sh"
    exit 1
fi

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
    picom \
    scrot \
    dunst \
    brightnessctl \
    playerctl \
    lxappearance \
    pavucontrol \
    arandr \
    network-manager-gnome \
    blueman \
    fonts-font-awesome \
    gtk3-nocsd \
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

echo "=== Setting up i3status config ==="
mkdir -p "$REAL_HOME/.config/i3status"
cp "$SCRIPT_DIR/i3status-config" "$REAL_HOME/.config/i3status/config"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/i3status/config"

echo "=== Setting up power menu ==="
mkdir -p "$REAL_HOME/.local/bin"
cp "$SCRIPT_DIR/powermenu" "$REAL_HOME/.local/bin/powermenu"
chmod +x "$REAL_HOME/.local/bin/powermenu"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.local/bin/powermenu"

echo "=== Copying wallpapers ==="
mkdir -p "$REAL_HOME/Pictures/wallpapers"
cp "$SCRIPT_DIR/wallpapers/"* "$REAL_HOME/Pictures/wallpapers/"
chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/Pictures/wallpapers"

echo "=== Applying GTK settings ==="
sudo -u "$REAL_USER" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u $REAL_USER)/bus" \
    gsettings set org.gnome.desktop.interface gtk-theme 'Breeze-Dark' 2>/dev/null || true
sudo -u "$REAL_USER" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u $REAL_USER)/bus" \
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

echo ""
echo "========================================="
echo "  Setup complete!"
echo "========================================="
echo ""
echo "  Log out and log back in to i3."
echo ""
echo "  Keybindings:"
echo "    Mod+Space      App launcher (rofi)"
echo "    Mod+Return     Terminal"
echo "    Mod+Shift+q    Kill window"
echo "    Mod+Shift+e    Power menu (lock/logout/reboot/shutdown)"
echo "    Mod+Shift+r    Restart i3"
echo "    Mod+r          Resize mode"
echo "    Mod+f          Fullscreen"
echo "    Mod+h/j/k/l    Focus left/down/up/right"
echo "    Mod+1-0        Switch workspace"
echo "    Mod+p/o        Move workspace between monitors"
echo "    Print          Screenshot"
echo ""
echo "  Settings apps:"
echo "    lxappearance        Appearance / GTK theme"
echo "    pavucontrol         Sound / Volume"
echo "    arandr              Display / Monitor layout"
echo "    nm-connection-editor  Network / WiFi"
echo "    blueman-manager     Bluetooth"
echo ""
