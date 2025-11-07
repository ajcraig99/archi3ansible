#!/bin/bash

PIDFILE="/tmp/ffmpeg_recording.pid"

if [ -f "$PIDFILE" ]; then
    # Stop recording
    PID=$(cat "$PIDFILE")
    kill -INT $PID  # Send interrupt signal (like Ctrl+C)
    rm "$PIDFILE"
    notify-send "Screen Recording" "Recording stopped"
else
    # Start recording
    slop -f "ffmpeg -f x11grab -video_size %wx%h -framerate 30 -i :0.0+%x,%y -c:v libx264 -preset ultrafast ~/Videos/recording_$(date +%Y-%m-%d_%H-%M-%S).mkv" | bash &
    echo $! > "$PIDFILE"
    notify-send "Screen Recording" "Recording started"
fi
