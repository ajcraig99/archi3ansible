#!/bin/bash
# Rofi WiFi menu with signal strength icons

# Get list of available networks
networks=$(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi | grep -v '^:' | sort -t: -k3 -nr)

# Format for rofi display with signal strength icons
formatted_networks=$(echo "$networks" | while IFS=: read -r ssid security signal; do
    if [ -n "$ssid" ]; then
        # Choose icon based on signal strength
        if [ "$signal" -ge 80 ]; then
            strength_icon="󰤨"  # Excellent (4 bars)
        elif [ "$signal" -ge 60 ]; then
            strength_icon="󰤥"  # Good (3 bars)
        elif [ "$signal" -ge 40 ]; then
            strength_icon="󰤢"  # Fair (2 bars)
        elif [ "$signal" -ge 20 ]; then
            strength_icon="󰤟"  # Weak (1 bar)
        else
            strength_icon="󰤯"  # Very weak
        fi
        
        # Add security icon
        if [ "$security" = "--" ]; then
            echo "$strength_icon   $ssid - $signal%"
        else
            echo "$strength_icon   $ssid - $signal%"
        fi
    fi
done)

# Show menu
selected=$(echo "$formatted_networks" | rofi -dmenu -i -p "WiFi Networks: ")

if [ -n "$selected" ]; then
    # Extract SSID from selection
    ssid=$(echo "$selected" | sed 's/^[^ ]* *//' | sed 's/ 🔒//' | sed 's/ (.*//')
    
    # Connect to network
    if nmcli dev wifi connect "$ssid"; then
        echo "Connected to $ssid"
    else
        password=$(echo "" | rofi -dmenu -password -p "Password for $ssid")
        if [ -n "$password" ]; then
            nmcli dev wifi connect "$ssid" password "$password"
        fi
    fi
fi
