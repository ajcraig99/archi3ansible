#!/bin/bash

INTERFACE="xps15"

# Check if WireGuard interface is up
if ip link show "$INTERFACE" &> /dev/null; then
    # Interface exists, check if it has peers
    if sudo wg show "$INTERFACE" 2>/dev/null | grep -q "peer"; then
        echo '{"text": "🔒", "class": "connected", "tooltip": "WireGuard: Connected"}'
    else
        echo '{"text": "🔓", "class": "disconnected", "tooltip": "WireGuard: Interface up but no peers"}'
    fi
else
    echo '{"text": "🔓", "class": "disconnected", "tooltip": "WireGuard: Disconnected"}'
fi
