#!/bin/bash
# Install polybar and icon fonts for i3
# Run with: sudo ./install-polybar.sh

set -e

echo "=== Installing polybar and fonts ==="
apt update
apt install -y polybar fonts-font-awesome fonts-materialdesignicons-webfont

echo ""
echo "=== Done! ==="
echo "Now restart i3 (Mod+Shift+r) or run: i3-msg restart"
echo "Polybar will automatically replace i3status."
