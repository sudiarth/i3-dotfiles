#!/bin/bash
# Wraps i3status output to inject Cloudflare WARP status into i3bar

i3status -c ~/.config/i3status/config | while IFS= read -r line; do
    # Pass version header and opening bracket unchanged
    if [[ "$line" == '{"version":'* ]] || [[ "$line" == '[' ]]; then
        echo "$line"
        continue
    fi

    # Get WARP status
    warp=$(warp-cli --accept-tos status 2>/dev/null | head -1 | awk '{print $NF}')
    if [ "$warp" = "Connected" ]; then
        icon=""; label="WARP"
    else
        icon=""; label="OFF"
    fi
    warp_json="{\"full_text\":\"<span foreground='#919191'>  ${icon}  </span><span foreground='#C2C2C2'>  ${label}  </span>\",\"markup\":\"pango\"}"

    # Strip leading comma from continuation lines
    comma=""
    if [[ "$line" == ,* ]]; then
        comma=","
        line="${line:1}"
    fi

    # Parse the JSON array, insert WARP block at position 3 (after memory)
    modified=$(echo "$line" | jq -c --argjson warp "$warp_json" '.[0:3] + [$warp] + .[3:]')
    echo "${comma}${modified}"
done
