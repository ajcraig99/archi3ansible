#!/bin/bash

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then

    rofi -show drun -theme ~/.config/rofi/applauncher.rasi "$@"
else
    # X11/i3 - use basic gruvbox
    rofi -show drun -theme ~/.config/rofi/applauncher.rasi "$@"
fi
