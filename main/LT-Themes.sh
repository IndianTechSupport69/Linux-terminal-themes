#!/bin/bash

# Check for installed terminal emulators in the user's .config folder
check_terminal() {
    local terminal=$1
    if [ -d "$HOME/.config/$terminal" ]; then
        echo "$terminal is installed."
    else
        echo "$terminal is not installed."
    fi
}

# List of common terminal emulators
terminals=("gnome-terminal" "konsole" "xfce4-terminal" "tilix" "alacritty" "terminator" "kitty" "st" "urxvt")

# Check each terminal emulator
for terminal in "${terminals[@]}"; do
    check_terminal "$terminal"
done