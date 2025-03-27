#!/bin/bash

# Open Firefox in private window with kiosk mode (fullscreen)
firefox --kiosk --private-window "https://www.hackerrank.com/code-clash-1742887396" &

# Wait for Firefox to fully load
sleep 10

# Capture Firefox window ID
FIREFOX_WINDOW=$(xdotool search --onlyvisible --class "Firefox" | head -n 1)

# Function to disable critical shortcuts (EXCLUDING Alt keys)
disable_keys() {
    xmodmap -e "keycode 71 = NoSymbol"  # Disable F5 (Refresh)
    xmodmap -e "keycode 95 = NoSymbol"  # Disable F11 (Fullscreen exit)
    xmodmap -e "keycode 133 = NoSymbol" # Disable Left Windows key (Super_L)
    xmodmap -e "keycode 134 = NoSymbol" # Disable Right Windows key (Super_R)
    xmodmap -e "keycode 23 = NoSymbol"  # Disable Tab
    xmodmap -e "keycode 37 = NoSymbol"  # Disable Left Ctrl
    xmodmap -e "keycode 105 = NoSymbol" # Disable Right Ctrl
}

# Restore original key bindings
restore_keys() {
    setxkbmap -option
}

# Disable critical keys (Alt keys are excluded to allow Alt + F4)
disable_keys

echo "Press Alt + F4 to exit."

# Main loop to keep Firefox in focus and monitor exit
while true; do
    xdotool windowactivate $FIREFOX_WINDOW  # Ensure Firefox stays in focus

    # Exit if Firefox closes
    if ! xdotool search --onlyvisible --class "Firefox"; then
        break
    fi

    sleep 1
done

# Restore all keys and close Firefox
restore_keys
pkill firefox
