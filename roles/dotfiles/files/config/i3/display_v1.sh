#!/bin/bash

# Function to wait for a display to be detected
wait_for_display() {
    local max_attempts=10
    local attempt=0
    
    echo "Waiting for external displays to be detected..."
    
    while [ $attempt -lt $max_attempts ]; do
        if xrandr | grep -E "^DP-?[0-9]+ connected" > /dev/null; then
            echo "External display detected on attempt $((attempt + 1))"
            return 0
        fi
        
        attempt=$((attempt + 1))
        sleep 1
    done
    
    echo "No external display detected after $max_attempts attempts"
    return 1
}

# Wait longer initially for USB-C hub enumeration
sleep 2

# Disable display power management to prevent blanking
xset -dpms
xset s off

# Check if laptop lid is open
if xrandr | grep "^eDP1 connected" > /dev/null; then
    xrandr --output eDP1 --mode 2560x1440 --rate 60 --dpi 96 --primary --pos 0x0
    laptop_active=true
else
    laptop_active=false
fi

# Wait for external displays
wait_for_display

# Configure any connected DP output
for output in $(xrandr | grep -E "^DP-?[0-9]+ connected" | awk '{print $1}'); do
    echo "Configuring $output"
    if [ "$laptop_active" = true ]; then
        xrandr --output "$output" --mode 3840x2160 --rate 30 --dpi 96 --right-of eDP1
    else
        xrandr --output eDP1 --off
        xrandr --output "$output" --mode 3840x2160 --rate 30 --dpi 96 --primary --pos 0x0
    fi
done

# Wait for display to stabilize
sleep 1

# Restart polybar
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
~/.config/polybar/launch.sh &

# Refresh wallpaper
feh --bg-scale ~/.config/i3/wallpaper.jpg &
