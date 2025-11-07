#!/bin/bash

# Check if brightnessctl is available
if ! command -v brightnessctl &> /dev/null; then
    echo "Error: brightnessctl not found. Please install it first."
    exit 1
fi

get_brightness() {
    # Get current brightness percentage from brightnessctl
    brightness=$(brightnessctl -m | cut -d, -f4 | tr -d '%')
    
    # If brightnessctl fails, return 50 as fallback
    if [[ -z "$brightness" ]] || ! [[ "$brightness" =~ ^[0-9]+$ ]]; then
        brightness=50
    fi
    
    echo "$brightness"
}

set_brightness() {
    if [[ "$1" -ge 5 && "$1" -le 100 ]] 2>/dev/null; then
        brightnessctl set "${1}%" > /dev/null 2>&1
    fi
}

case "$1" in
    get)
        brightness=$(get_brightness)
        printf '{"text": "󰃞", "percentage": %d, "tooltip": "Brightness: %d%%"}\n' "$brightness" "$brightness"
        ;;
    set)
        set_brightness "$2"
        ;;
    get-percentage)
        get_brightness
        ;;
    up)
        current=$(get_brightness)
        new_brightness=$((current + 5))
        if [[ $new_brightness -le 100 ]]; then
            set_brightness "$new_brightness"
        fi
        ;;
    down)
        current=$(get_brightness)
        new_brightness=$((current - 5))
        if [[ $new_brightness -ge 5 ]]; then
            set_brightness "$new_brightness"
        fi
        ;;
    *)
        echo "Usage: $0 {get|set|get-percentage|up|down} [value]"
        exit 1
        ;;
esac
