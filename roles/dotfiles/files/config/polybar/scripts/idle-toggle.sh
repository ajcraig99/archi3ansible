#!/bin/bash

# Adapt this to your idle inhibitor (xautolock, caffeine, etc.)
if [ "$1" = "status" ]; then
    if pgrep -x xautolock > /dev/null; then
        echo "󰈉"  # idle enabled
    else
        echo "󰈈"  # idle disabled
    fi
elif [ "$1" = "toggle" ]; then
    if pgrep -x xautolock > /dev/null; then
        pkill xautolock
    else
        xautolock -time 10 -locker "i3lock" &
    fi
fi
