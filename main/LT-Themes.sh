#!/bin/bash

# Check for installed terminal emulator packages
check_terminal() {
    local terminal=$1
    if command -v "$terminal" &> /dev/null; then
        installed_terminals+=("$terminal")
    fi
}

# Check each terminal emulator
terminals=(
    "gnome-terminal"
    "konsole"
    "xfce4-terminal"
    "tilix"
    "alacritty"
    "terminator"
    "kitty"
    "urxvt"
    "lxterminal"
    "terminology"
    "hyper"
    "tilda"
    "guake"
    "yakuake"
    "mate-terminal"
    "deepin-terminal"
    "eterm"
    "sakura"
    "qterminal"
    "st"
)

installed_terminals=()

for terminal in "${terminals[@]}"; do
    check_terminal "$terminal"
done

if [ ${#installed_terminals[@]} -eq 0 ]; then
    echo "No terminal emulators are installed."
    exit 1
fi

echo "Select a terminal to configure:"
select terminal in "${installed_terminals[@]}"; do
    if [ -n "$terminal" ]; then
        echo "You selected $terminal"
        if [ "$terminal" == "kitty" ]; then
            if [ -f "$(dirname "$0")/themes/kitty/kitty.conf" ]; then
                mkdir -p ~/.config/kitty
                cp "$(dirname "$0")/themes/kitty/kitty.conf" ~/.config/kitty/kitty.conf
                echo "kitty configuration has been updated."
            else
                echo "kitty.conf not found in $(dirname "$0")/themes/kitty/"
            fi
        fi
        # Add your configuration code for other terminals here
        break
    else
        echo "Invalid selection. Please try again."
    fi
done