#!/bin/bash
(
    if ip link show xps15 &> /dev/null && ip link show xps15 | grep -q "state UP"; then
        sudo wg-quick down xps15
    else
        sudo wg-quick up xps15
    fi
    
    # Trigger immediate update after connection change
    polybar-msg hook wireguard 1
) &
