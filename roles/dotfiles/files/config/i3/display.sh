#!/bin/bash

# Give the system more time to fully initialize after boot
sleep 3

wait_for_display() {
    local max_attempts=20
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if xrandr | grep -E "^DP-?[0-9]+ connected" > /dev/null; then
            return 0
        fi
        attempt=$((attempt + 1))
        sleep 0.2
    done
    return 1
}

xset -dpms
xset s off

# Dynamically detect the laptop display name (eDP-1 or eDP1)
LAPTOP_DISPLAY=$(xrandr | grep -oP "^eDP-?[0-9]+" | head -1)
echo "Detected laptop display: $LAPTOP_DISPLAY"

# Check lid state
lid_state="unknown"
if [ -f /proc/acpi/button/lid/LID0/state ]; then
    lid_state=$(grep -oP '(?<=state:\s{6})\w+' /proc/acpi/button/lid/LID0/state)
    echo "Lid state from ACPI: $lid_state"
fi

# Decide laptop state
if [ "$lid_state" = "closed" ]; then
    echo "Lid is closed - external monitor only mode"
    laptop_active=false
else
    echo "Lid is open - extended desktop mode"
    laptop_active=true
fi

# Configure displays based on lid state
if [ "$laptop_active" = true ]; then
    xrandr --output "$LAPTOP_DISPLAY" --mode 2560x1440 --rate 60 --dpi 96 --primary --pos 0x0
fi

wait_for_display

# Configure external displays - dynamically detect DP port names
for output in $(xrandr | grep -E "^DP-?[0-9]+ connected" | awk '{print $1}'); do
    echo "Configuring $output..."
    if [ "$laptop_active" = false ]; then
        # Laptop closed: external as primary, laptop off
        xrandr --output "$LAPTOP_DISPLAY" --off
        xrandr --output "$output" --mode 3840x2160 --rate 30 --dpi 96 --primary --pos 0x0
    else
        # Laptop open: extended desktop
        xrandr --output "$output" --mode 3840x2160 --rate 30 --dpi 96 --left-of "$LAPTOP_DISPLAY"
    fi
done

sleep 0.5

# Launch polybar
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done
~/.config/polybar/launch.sh &

# Refresh wallpaper
feh --bg-scale ~/.config/i3/wallpaper.jpg &

echo "Display setup complete"
