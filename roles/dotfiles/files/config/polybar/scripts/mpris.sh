#!/bin/bash

status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    title=$(playerctl metadata title 2>/dev/null)
    artist=$(playerctl metadata artist 2>/dev/null)
    
    if [ -n "$title" ] && [ -n "$artist" ]; then
        output="$artist - $title"
        # Truncate if too long
        if [ ${#output} -gt 60 ]; then
            output="${output:0:57}..."
        fi
        echo "$output"
    fi
elif [ "$status" = "Paused" ]; then
    echo "⏸"
fi
