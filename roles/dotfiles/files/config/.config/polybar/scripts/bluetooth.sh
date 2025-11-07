#!/bin/bash
if rfkill list bluetooth | grep -q "yes"; then
    echo "󰂲"  # disabled
elif bluetoothctl info | grep -q "Connected: yes"; then
    echo "󰂱"  # connected
else
    echo ""   # on but not connected
fi
