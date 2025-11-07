#!/bin/bash
# Fuzzy file search with fd and rofi
selected=$(fd -t f -H . ~ | rofi -dmenu -i -matching fuzzy -p "Search files: ")
if [ -n "$selected" ]; then
    xdg-open "$selected"
fi
