#!/bin/bash

# Colors for polybar
green=#b8bb26
red=#fb4934
foreground=#ebdbb2
blue=#458588

# Your WireGuard interface name
interface="xps15"

# Check if VPN is connected using wg show
STATUS=$(sudo wg show "$interface" 2>/dev/null | grep interface)

connect() {
    sudo wg-quick up "$interface" && dunstify "WireGuard" "$interface Connected" -u normal 2>/dev/null
}

disconnect() {
    sudo wg-quick down "$interface" && dunstify "WireGuard" "$interface Disconnected" -u normal 2>/dev/null
}

toggle() {
    if [ -n "$STATUS" ]; then
        disconnect
    else
        connect
    fi
}

print() {
    if [ -n "$STATUS" ]; then
        echo "%{F$blue}󰒃%{F-}"
    else
        echo "%{F$foreground}󰒃%{F-}"
    fi
}

case "$1" in
    --toggle)
        toggle
        ;;
    *)
        print
        ;;
esac
