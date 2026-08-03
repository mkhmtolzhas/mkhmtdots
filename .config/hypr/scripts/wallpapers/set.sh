#!/bin/bash
set -eu

WALL=$1

awww img --transition-type center --transition-step 90 "$WALL"
echo "Wallpaper set successfully"

# --- matugen: primary colour generator (quickshell, kitty, rofi, mako, hyprland) ---
if command -v matugen >/dev/null 2>&1; then
    echo "Generating matugen colors..."
    matugen image "$WALL" --type scheme-content --mode dark --prefer saturation || echo "matugen failed"
    hyprctl reload >/dev/null 2>&1 || true
    # reload resets animations.lua → restore workspace slide direction set by quickshell
    ws_style=$(cat "$HOME/.cache/quickshell-ws-anim" 2>/dev/null || echo slide)
    hyprctl eval "hl.animation({ leaf = 'workspaces', enabled = true, speed = 5, bezier = 'wind', style = '$ws_style' })" >/dev/null 2>&1 || true
    pkill -USR1 kitty 2>/dev/null || true   # live-reload kitty colors (re-reads include)
    "$HOME/.config/keyboard/set-color-keyboard.sh" >/dev/null 2>&1 &   # keyboard backlight from matugen
fi

# --- pywal: optional, kept only for Firefox (pywalfox) and Discord ---
if command -v wal >/dev/null 2>&1; then
    echo "applying pywal colors (firefox/discord)..."
    wal -i "$WALL" -s -t
    echo "pywal applied successfully"
else
    echo "pywal not installed, skipping"
fi
