#!/bin/bash

# Get the default WiFi interface
WIFI_INTERFACE=$(ip link | grep -E '^[0-9]+: w' | awk -F': ' '{print $2}' | head -n 1)

# Check if WiFi interface exists and is up
if [ -z "$WIFI_INTERFACE" ] || ! ip link show "$WIFI_INTERFACE" | grep -q "state UP"; then
    echo "󰖪"  # WiFi disabled
    exit 0
fi

# Check if connected to a network
SSID=$(iw dev "$WIFI_INTERFACE" link | grep 'SSID' | awk '{print $2}')

if [ -z "$SSID" ]; then
    echo "󰤭"  # WiFi disconnected
    exit 0
fi

# Get signal strength in dBm
SIGNAL=$(iw dev "$WIFI_INTERFACE" link | grep 'signal' | awk '{print $2}')
SIGNAL_ABS=${SIGNAL#-}

# Convert signal strength to percentage (rough approximation)
# -30 dBm = 100%, -90 dBm = 0%
if [ "$SIGNAL_ABS" -le 30 ]; then
    PERCENTAGE=100
elif [ "$SIGNAL_ABS" -ge 90 ]; then
    PERCENTAGE=0
else
    PERCENTAGE=$((100 - (SIGNAL_ABS - 30) * 100 / 60))
fi

# Select icon based on signal strength
if [ "$PERCENTAGE" -ge 80 ]; then
    ICON="󰤨"  # Excellent (4 bars)
elif [ "$PERCENTAGE" -ge 60 ]; then
    ICON="󰤥"  # Good (3 bars)
elif [ "$PERCENTAGE" -ge 40 ]; then
    ICON="󰤢"  # Fair (2 bars)
elif [ "$PERCENTAGE" -ge 20 ]; then
    ICON="󰤟"  # Weak (1 bar)
else
    ICON="󰤯"  # Very weak
fi

# Output options - uncomment your preferred format:

# Option 1: Just icon
# echo "$ICON"

# Option 2: Icon with percentage
echo "$ICON ${PERCENTAGE}%"

# Option 3: Icon with SSID
# echo "$ICON $SSID"

# Option 4: Icon with SSID and percentage
# echo "$ICON $SSID ${PERCENTAGE}%"
