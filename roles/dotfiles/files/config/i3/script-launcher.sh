
#!/bin/bash

SCRIPT_DIR="$HOME/scripts"
declare -A SCRIPT_MAP

# Build list for Rofi
menu=""
while IFS= read -r script; do
    name=$(grep -m1 '^#NAME:' "$script" | sed 's/^#NAME:[[:space:]]*//')
    [ -z "$name" ] && name=$(basename "$script")
    filename=$(basename "$script")
    SCRIPT_MAP["$name"]="$filename"
    menu+="$name\n"
done < <(find "$SCRIPT_DIR" -maxdepth 1 -type f -executable -name "*.sh" | sort)

# Show menu
selection=$(echo -e "$menu" | rofi -dmenu -i -p "Run script:" -theme ~/.config/rofi/scriptmenu.rasi)
[ -z "$selection" ] && exit

script="${SCRIPT_MAP["$selection"]}"

# Run the chosen script
if grep -q "^#INTERACTIVE" "$SCRIPT_DIR/$script"; then
    SOCKET="unix:/tmp/kitty"

    if kitten @ --to "$SOCKET" ls &>/dev/null; then
        kitten @ --to "$SOCKET" launch --type=tab --tab-title "$selection" bash -c "\"$SCRIPT_DIR/$script\"; exec bash"
    else
        kitty --listen-on "$SOCKET" --title "$selection" bash -c "\"$SCRIPT_DIR/$script\"; exec bash"
    fi
else
    "$SCRIPT_DIR/$script" &
fi

