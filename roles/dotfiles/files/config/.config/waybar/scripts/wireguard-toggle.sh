#!/bin/bash

INTERFACE="xps15"

# Function to check if WireGuard is connected
is_connected() {
    if ip link show "$INTERFACE" &> /dev/null; then
        if sudo wg show "$INTERFACE" 2>/dev/null | grep -q "peer"; then
            return 0  # Connected
        fi
    fi
    return 1  # Not connected
}

if is_connected; then
    echo "Disconnecting..."
    sudo wg-quick down "$INTERFACE"
    notify-send "WireGuard" "Disconnected from $INTERFACE" -i network-vpn-symbolic
else
    echo "Connecting..."
    sudo wg-quick up "$INTERFACE"
    notify-send "WireGuard" "Connected to $INTERFACE" -i network-vpn-symbolic
fi
