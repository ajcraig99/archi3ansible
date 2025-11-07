#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar only on active monitors (those with a resolution set)
if type "xrandr" > /dev/null; then
  for m in $(xrandr --query | grep " connected" | grep -oP "^\S+(?=.*\d+x\d+)"); do
    echo "Launching polybar on active monitor: $m"
    MONITOR=$m polybar --reload main 2>&1 | tee -a /tmp/polybar-$m.log & disown
  done
else
  polybar main 2>&1 | tee -a /tmp/polybar.log & disown
fi

echo "Polybar launched on all active monitors"
