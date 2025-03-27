#!/bin/bash

# Ensure required packages are installed
for pkg in firefox xdotool x11-xserver-utils; do
    if ! command -v $pkg &> /dev/null; then
        echo "$pkg is missing. Installing..."
        sudo apt update && sudo apt install $pkg -y
    fi
done

# Open Firefox in private mode
firefox --private-window "https://www.hackerrank.com/code-clash-1742887396" &

# Wait for Firefox to load
sleep 10

# Capture Firefox window ID
FIREFOX_WINDOW=$(xdotool search --onlyvisible --class "Firefox" | head -n 1)

# Force Fullscreen (if kiosk fails)
xdotool windowactivate $FIREFOX_WINDOW
xdotool key F11

# Function to disable common shortcuts
disable_keys() {
    # Windows keys (Super_L and Super_R)
    xmodmap -e "keycode 133 = NoSymbol" # Left Windows Key
    xmodmap -e "keycode 134 = NoSymbol" # Right Windows Key

    # Navigation keys
    xmodmap -e "keycode 23 = NoSymbol"  # Tab (Disables Alt+Tab)
    xmodmap -e "keycode 37 = NoSymbol"  # Left Ctrl
    xmodmap -e "keycode 105 = NoSymbol" # Right Ctrl
    xmodmap -e "keycode 64 = NoSymbol"  # Left Alt (Optionally disable if needed)
    xmodmap -e "keycode 108 = NoSymbol" # Right Alt

    # Function keys
    xmodmap -e "keycode 71 = NoSymbol"  # F5 (Refresh)
    xmodmap -e "keycode 95 = NoSymbol"  # F11 (Fullscreen exit)
    xmodmap -e "keycode 67 = NoSymbol"  # F1 (Help Menu)

    echo "Shortcut keys disabled."
}

# Restore original keys
restore_keys() {
    echo "Restoring keys..."
    setxkbmap -option
}

# Ensure Firefox remains in focus
keep_focused() {
    while true; do
        # Keep Firefox on top
        xdotool windowactivate $FIREFOX_WINDOW

        # Check if Firefox is closed
        if ! xdotool search --onlyvisible --class "Firefox"; then
            break
        fi

        sleep 1
    done
}

# Main Execution
disable_keys
echo "Press Alt + F4 to exit."

# Keep Firefox in focus and monitor for exit
keep_focused

# Restore keys and clean up after exit
restore_keys
pkill firefox
