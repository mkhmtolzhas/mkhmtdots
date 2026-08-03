#!/usr/bin/env bash
# Generate matugen colours from a wallpaper and apply them everywhere
# (quickshell, kitty, rofi, mako, hyprland, nvim, keyboard backlight).
#
# Usage: ./scripts/apply-matugen.sh [/path/to/wallpaper]
# With no argument it picks the first image in ~/.config/wallpapers.
set -euo pipefail

WALL="${1:-}"
if [[ -z "$WALL" ]]; then
  WALL="$(find "$HOME/.config/wallpapers" -type f \
            \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) 2>/dev/null | head -1)"
fi

if [[ -z "$WALL" || ! -f "$WALL" ]]; then
  echo "No wallpaper found — skipping matugen."
  exit 0
fi

if ! command -v matugen >/dev/null 2>&1; then
  echo "matugen not installed — skipping."
  exit 0
fi

echo "Generating matugen colours from: $WALL"
matugen image "$WALL" --type scheme-content --mode dark --prefer saturation

# Keyboard backlight (best-effort; needs legion-kb-rgb).
if [[ -x "$HOME/.config/keyboard/set-color-keyboard.sh" ]]; then
  bash "$HOME/.config/keyboard/set-color-keyboard.sh" >/dev/null 2>&1 || true
fi

# Reload Hyprland colours and restore the workspace slide direction.
if command -v hyprctl >/dev/null 2>&1; then
  hyprctl reload >/dev/null 2>&1 || true
  ws_style="$(cat "$HOME/.cache/quickshell-ws-anim" 2>/dev/null || echo slide)"
  hyprctl eval "hl.animation({ leaf = 'workspaces', enabled = true, speed = 5, bezier = 'wind', style = '$ws_style' })" >/dev/null 2>&1 || true
fi

echo "Theme applied."
