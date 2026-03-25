#!/bin/bash
# =============================================================================
# i3 Desktop Setup - Single Install Script
# =============================================================================
# Sets up i3 with cyberpunk theme, rofi, i3status, wallpapers, multi-monitor,
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
    git \
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
    gnome-keyring \
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
echo "=== Installing Poppins font ==="
mkdir -p "$REAL_HOME/.local/share/fonts"
FONT_TMP=$(mktemp -d)
for weight in Regular Bold Medium; do
    curl -sL "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-${weight}.ttf" \
        -o "$REAL_HOME/.local/share/fonts/Poppins-${weight}.ttf"
done
chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.local/share/fonts"
sudo -u "$REAL_USER" fc-cache -f

echo ""
echo "=== Setting up i3 config ==="
mkdir -p "$REAL_HOME/.config/i3"
cp "$SCRIPT_DIR/i3-config" "$REAL_HOME/.config/i3/config"
cp "$SCRIPT_DIR/show-keys.sh" "$REAL_HOME/.config/i3/show-keys.sh"
cp "$SCRIPT_DIR/lock.sh" "$REAL_HOME/.config/i3/lock.sh"
chmod +x "$REAL_HOME/.config/i3/show-keys.sh"
chmod +x "$REAL_HOME/.config/i3/lock.sh"
chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/i3"

echo "=== Setting up i3status config ==="
mkdir -p "$REAL_HOME/.config/i3status"
cp "$SCRIPT_DIR/i3status-config" "$REAL_HOME/.config/i3status/config"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/i3status/config"

echo "=== Setting up xsessionrc (GNOME Keyring) ==="
cp "$SCRIPT_DIR/xsessionrc" "$REAL_HOME/.xsessionrc"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.xsessionrc"

echo "=== Setting up adi1090x/rofi themes ==="
ROFI_TMP=$(mktemp -d)
sudo -u "$REAL_USER" git clone --depth 1 https://github.com/adi1090x/rofi.git "$ROFI_TMP"
# Run the setup script as the real user (it copies files to ~/.config/rofi)
sudo -u "$REAL_USER" bash "$ROFI_TMP/setup.sh" <<< "Y" || true
rm -rf "$ROFI_TMP"

# Apply Nord color scheme to all rofi components
echo "=== Applying Nord color scheme to rofi ==="
for colors_file in $(find "$REAL_HOME/.config/rofi" -path "*/shared/colors.rasi"); do
    cat > "$colors_file" << 'RASI'
/**
 *
 * Author : Aditya Shakya (adi1090x)
 * Github : @adi1090x
 * 
 * Colors
 *
 * Available Colors Schemes
 *
 * adapta    catppuccin    everforest    navy       paper
 * arc       cyberpunk     gruvbox       nord       solarized
 * black     dracula       lovelace      nord    yousai
 *
 **/

/* Import color-scheme from `colors` directory */

@import "~/.config/rofi/colors/nord.rasi"
RASI
    chown "$REAL_USER:$REAL_USER" "$colors_file"
done

echo "=== Copying wallpapers ==="
mkdir -p "$REAL_HOME/Pictures/wallpapers"
cp "$SCRIPT_DIR/wallpapers/"* "$REAL_HOME/Pictures/wallpapers/"
chown -R "$REAL_USER:$REAL_USER" "$REAL_HOME/Pictures/wallpapers"

echo "=== Applying GTK settings ==="
mkdir -p "$REAL_HOME/.config/gtk-4.0"
cp "$SCRIPT_DIR/gtk4.css" "$REAL_HOME/.config/gtk-4.0/gtk.css"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/gtk-4.0/gtk.css"
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
echo "    Mod+F1         Show all keybindings"
echo "    Print          Screenshot"
echo ""
echo "  Settings apps:"
echo "    lxappearance        Appearance / GTK theme"
echo "    pavucontrol         Sound / Volume"
echo "    arandr              Display / Monitor layout"
echo "    nm-connection-editor  Network / WiFi"
echo "    blueman-manager     Bluetooth"
echo ""
