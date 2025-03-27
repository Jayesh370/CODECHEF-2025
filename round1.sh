#!/bin/bash

# Ensure required packages are installed
if ! command -v firefox &> /dev/null; then
    echo "Firefox is not installed. Installing now..."
    sudo apt update && sudo apt install firefox -y
fi

if ! command -v xdotool &> /dev/null; then
    echo "xdotool is not installed. Installing now..."
    sudo apt update && sudo apt install xdotool -y
fi

if ! command -v xmodmap &> /dev/null; then
    echo "xmodmap is not installed. Installing now..."
    sudo apt update && sudo apt install x11-xserver-utils -y
fi

# Open Firefox in private mode (fullscreen via xdotool)
firefox --private-window "https://www.hackerrank.com/code-clash-1742887396" &

# Wait for Firefox to fully load
sleep 10

# Capture Firefox window ID
FIREFOX_WINDOW=$(xdotool search --onlyvisible --class "Firefox" | head -n 1)

# Force Fullscreen (if kiosk fails)
xdotool windowactivate $FIREFOX_WINDOW
xdotool key F11

# Function to disable critical shortcuts (including Alt+Tab prevention)
disable_keys() {
    xmodmap -e "keycode 71 = NoSymbol"  # Disable F5 (Refresh)
    xmodmap -e "keycode 95 = NoSymbol"  # Disable F11 (Fullscreen exit)
    xmodmap -e "keycode 133 = NoSymbol" # Disable Left Windows key (Super_L)
    xmodmap -e "keycode 134 = NoSymbol" # Disable Right Windows key (Super_R)
    xmodmap -e "keycode 23 = NoSymbol"  # Disable Tab (for Alt+Tab prevention)
    xmodmap -e "keycode 37 = NoSymbol"  # Disable Left Ctrl
    xmodmap -e "keycode 105 = NoSymbol" # Disable Right Ctrl
}

# Restore original key bindings
restore_keys() {
    setxkbmap -option
}

# Disable critical keys (Alt keys excluded to allow Alt+F4 for exit)
disable_keys

echo "Firefox is in fullscreen mode. Press Alt + F4 to exit."

# Main loop to keep Firefox in focus and monitor exit
while true; do
    # Keep Firefox on top
    xdotool windowactivate $FIREFOX_WINDOW

    # Exit loop if Firefox is closed
    if ! xdotool search --onlyvisible --class "Firefox"; then
        break
    fi

    sleep 1
done

# Restore all keybindings and close Firefox
restore_keys
pkill firefox
