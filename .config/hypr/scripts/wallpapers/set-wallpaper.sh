#!/bin/bash
set -eu

WALL_DIR="$HOME/.config/wallpapers"


if [ ! -d "$WALL_DIR" ]; then
    echo "Cannot find directory with wallpapers: $WALL_DIR"
    exit 1
fi

FILE_LIST=$(find "$WALL_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.gif" \) -printf "%f\n")

SELECTED_FILE=$(echo "$FILE_LIST" | rofi -dmenu -p "Select wallpaper")

[ -z "$SELECTED_FILE" ] && exit 1

WALL="$WALL_DIR/$SELECTED_FILE"
echo "Setting wallpaper: $SELECTED_FILE"
awww img --transition-type center --transition-step 90 "$WALL"
echo "Wallpaper set successfully"

# --- matugen: primary colour generator (quickshell, kitty, rofi, mako, hyprland) ---
if command -v matugen >/dev/null 2>&1; then
    echo "Generating matugen colors (scheme-content, dark)..."
    matugen image "$WALL" --type scheme-content --mode dark --prefer saturation || echo "matugen failed"
    hyprctl reload >/dev/null 2>&1 || true
    # reload resets animations.lua → restore workspace slide direction set by quickshell
    ws_style=$(cat "$HOME/.cache/quickshell-ws-anim" 2>/dev/null || echo slide)
    hyprctl eval "hl.animation({ leaf = 'workspaces', enabled = true, speed = 5, bezier = 'wind', style = '$ws_style' })" >/dev/null 2>&1 || true
    pkill -USR1 kitty 2>/dev/null || true   # live-reload kitty colors (re-reads include)
    KEYBOARD_SCRIPT="$HOME/.config/keyboard/set-color-keyboard.sh"
    [ -x "$KEYBOARD_SCRIPT" ] && bash "$KEYBOARD_SCRIPT" >/dev/null 2>&1 &   # keyboard backlight from matugen
    echo "matugen applied"
else
    echo "matugen not installed, skipping"
fi

# --- pywal: optional, kept only for Firefox (pywalfox) and Discord ---
if command -v wal >/dev/null 2>&1; then
    echo "Applying pywal colors (firefox/discord)..."
    wal -i "$WALL" -s -t
    echo "Pywal applied successfully"
    
    
    export PATH="$HOME/.local/bin:$PATH:/usr/local/bin"
    
    if command -v pywalfox >/dev/null 2>&1; then
        echo "Updating pywalfox..."
        pywalfox update &
    else
        echo "pywalfox not found in PATH"
    fi
    
    
    wait
    
else
    echo "Pywal not installed, skipping"
fi
echo "All done!"
