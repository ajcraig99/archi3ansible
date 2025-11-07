#!/bin/bash

if pgrep -x ffmpeg > /dev/null || pgrep -x wf-recorder > /dev/null; then
    # Blink when recording
    if [ $(($(date +%s) % 2)) -eq 0 ]; then
        echo "%{F#fb4934}󰕧%{F-}"  # red
    else
        echo "󰕧"
    fi
else
    echo "󰕧"
fi
