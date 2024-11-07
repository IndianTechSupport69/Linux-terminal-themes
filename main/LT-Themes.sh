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
                if [ $? -ne 0 ]; then
                    echo "Permission denied. Please run the script with sudo."
                    exit 1
                fi
                echo "kitty configuration has been updated."
            else
                echo "kitty.conf not found in $(dirname "$0")/themes/kitty/"
            fi
        elif [ "$terminal" == "tilix" ]; then
            if [ -d "/usr/share/tilix/schemes" ]; then
                tilix_dir="/usr/share/tilix/schemes"
            elif [ -d "$HOME/.config/tilix/schemes" ]; then
                tilix_dir="$HOME/.config/tilix/schemes"
            else
                echo "No valid tilix schemes directory found."
                break
            fi

            theme_dir="$(dirname "$0")/themes/tilix"
            if [ ! -d "$theme_dir" ]; then
                echo "No tilix themes directory found in $theme_dir"
                break
            fi

            themes=($(ls "$theme_dir"/*.json 2>/dev/null))
            if [ ${#themes[@]} -eq 0 ]; then
                echo "No .json theme files found in $theme_dir"
                break
            fi

            echo "Available themes:"
            for theme in "${themes[@]}"; do
                echo "$(basename "$theme" .json)"
            done

            echo "Type the name of the theme you want to add or type ALL to add all themes:"
            read -r selected_theme

            if [ "$selected_theme" == "ALL" ]; then
                cp "$theme_dir"/*.json "$tilix_dir"
                if [ $? -ne 0 ]; then
                    echo "Permission denied. Please run the script with sudo."
                    exit 1
                fi
                echo "All themes have been copied to $tilix_dir"
            else
                if [ -f "$theme_dir/$selected_theme.json" ]; then
                    cp "$theme_dir/$selected_theme.json" "$tilix_dir"
                    if [ $? -ne 0 ]; then
                        echo "Permission denied. Please run the script with sudo."
                        exit 1
                    fi
                    echo "Theme $selected_theme has been copied to $tilix_dir"
                else
                    echo "Theme $selected_theme not found in $theme_dir"
                fi
            fi
        fi
        # Add your configuration code for other terminals here
        break
    else
        echo "Invalid selection. Please try again."
    fi
done
