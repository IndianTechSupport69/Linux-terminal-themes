#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for installed terminal emulator packages
check_terminal() {
    local terminal=$1
    if command -v "$terminal" &> /dev/null; then
        installed_terminals+=("$terminal")
    fi
}

# Check each terminal emulator
terminals=(
    "konsole" #done
    "xfce4-terminal"
    "tilix" #done
    "alacritty"
    "terminator"
    "kitty" #done
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
    echo -e "${RED}No terminal emulators are installed.${NC}"
    exit 1
fi

echo "Select a terminal to configure:"
select terminal in "${installed_terminals[@]}"; do
    if [ -n "$terminal" ]; then
        echo -e "${GREEN}You selected $terminal${NC}"
        if [ "$terminal" == "kitty" ]; then
            if [ -f "$(dirname "$0")/themes/kitty/kitty.conf" ]; then
                mkdir -p ~/.config/kitty
                if [ -f ~/.config/kitty/kitty.conf ]; then
                    mv ~/.config/kitty/kitty.conf ~/.config/kitty/old.kitty.conf
                    echo -e "${YELLOW}Old kitty.conf has been renamed to old.kitty.conf${NC}"
                fi
                cp "$(dirname "$0")/themes/kitty/kitty.conf" ~/.config/kitty/kitty.conf
                if [ $? -ne 0 ]; then
                    echo -e "${RED}Permission denied. Please run the script with sudo.${NC}"
                    exit 1
                fi
                echo -e "${GREEN}kitty configuration has been updated.${NC}"
            else
                echo -e "${RED}kitty.conf not found in $(dirname "$0")/themes/kitty/${NC}"
            fi
        elif [ "$terminal" == "tilix" ]; then
            if [ -d "/usr/share/tilix/schemes" ]; then
                tilix_dir="/usr/share/tilix/schemes"
            elif [ -d "$HOME/.config/tilix/schemes" ]; then
                tilix_dir="$HOME/.config/tilix/schemes"
            else
                echo -e "${RED}No valid tilix schemes directory found.${NC}"
                break
            fi

            theme_dir="$(dirname "$0")/themes/tilix"
            if [ ! -d "$theme_dir" ]; then
                echo -e "${RED}No tilix themes directory found in $theme_dir${NC}"
                break
            fi

            themes=($(ls "$theme_dir"/*.json 2>/dev/null))
            if [ ${#themes[@]} -eq 0 ]; then
                echo -e "${RED}No .json theme files found in $theme_dir${NC}"
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
                    echo -e "${RED}Permission denied. Please run the script with sudo.${NC}"
                    exit 1
                fi
                echo -e "${GREEN}All themes have been copied to $tilix_dir${NC}"
            else
                if [ -f "$theme_dir/$selected_theme.json" ]; then
                    cp "$theme_dir/$selected_theme.json" "$tilix_dir"
                    if [ $? -ne 0 ]; then
                        echo -e "${RED}Permission denied. Please run the script with sudo.${NC}"
                        exit 1
                    fi
                    echo -e "${GREEN}Theme $selected_theme has been copied to $tilix_dir${NC}"
                else
                    echo -e "${RED}Theme $selected_theme not found in $theme_dir${NC}"
                fi
            fi
        elif [ "$terminal" == "konsole" ]; then
            theme_dir="$(dirname "$0")/themes/konsole"
            if [ ! -d "$theme_dir" ]; then
                echo -e "${RED}No konsole themes directory found in $theme_dir${NC}"
                break
            fi

            themes=($(ls "$theme_dir"/*.colorscheme 2>/dev/null))
            if [ ${#themes[@]} -eq 0 ]; then
                echo -e "${RED}No .colorscheme theme files found in $theme_dir${NC}"
                break
            fi

            echo "Available themes:"
            for theme in "${themes[@]}"; do
                echo "$(basename "$theme" .colorscheme)"
            done

            echo "Type the name of the theme you want to add or type ALL to add all themes:"
            read -r selected_theme

            konsole_dir="$HOME/.local/share/konsole"
            mkdir -p "$konsole_dir"

            if [ "$selected_theme" == "ALL" ]; then
                cp "$theme_dir"/*.colorscheme "$konsole_dir"
                if [ $? -ne 0 ]; then
                    echo -e "${RED}Permission denied. Please run the script with sudo.${NC}"
                    exit 1
                fi
                echo -e "${GREEN}All themes have been copied to $konsole_dir${NC}"
            else
                if [ -f "$theme_dir/$selected_theme.colorscheme" ]; then
                    cp "$theme_dir/$selected_theme.colorscheme" "$konsole_dir"
                    if [ $? -ne 0 ]; then
                        echo -e "${RED}Permission denied. Please run the script with sudo.${NC}"
                        exit 1
                    fi
                    echo -e "${GREEN}Theme $selected_theme has been copied to $konsole_dir${NC}"
                else
                    echo -e "${RED}Theme $selected_theme not found in $theme_dir${NC}"
                fi
            fi
        else
            echo -e "${RED}Invalid selection. Please try again.${NC}"
        fi
        break
    fi
done