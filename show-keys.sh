#!/bin/bash
# Show i3 keybindings in rofi
cat <<'EOF' | rofi -dmenu -i -p "Keybindings" -theme-str 'window {width: 600px;}'
Win+Return         Terminal
Win+Shift+q        Kill window
Win+f              Fullscreen
Win+Shift+Space    Toggle floating
Win+r              Resize mode
Win+h/j/k/l        Focus left/down/up/right
Win+Shift+h/j/k/l  Move window
Win+1-0            Switch workspace
Win+Shift+1-0      Move to workspace
Win+p              Workspace to monitor up
Win+o              Workspace to monitor down
Win+b              Split horizontal
Win+v              Split vertical
Win+s              Stacking layout
Win+w              Tabbed layout
Win+e              Toggle split
Win+a              Focus parent
Win+Space          App launcher
Win+d              App launcher
Win+Shift+e        Power menu
Print              Screenshot
Win+Print          Screenshot selection
Win+Shift+c        Reload config
Win+Shift+r        Restart i3
Win+F1             This help
EOF
