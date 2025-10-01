#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/ghostty/config"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Ghostty config not found at $CONFIG_FILE"
    exit 1
fi

if [[ -d "/Applications/Ghostty.app" ]]; then
    readarray -t THEMES < <(ls "/Applications/Ghostty.app/Contents/Resources/ghostty/themes")
    THEME=${THEMES[$RANDOM % ${#THEMES[@]}]}
elif command -v ghostty >/dev/null 2>&1; then
    readarray -t THEMES < <(ghostty --list-themes)
    THEME=${THEMES[$RANDOM % ${#THEMES[@]}]}
else
    echo "Error: Neither Ghostty.app nor ghostty command found"
    exit 1
fi

if grep -q "^theme = " "$CONFIG_FILE" 2>/dev/null; then
    sed "s/^theme = .*/theme = $THEME/" "$CONFIG_FILE" > /tmp/ghostty_config && mv /tmp/ghostty_config "$CONFIG_FILE"
else
    echo "theme = $THEME" >> "$CONFIG_FILE"
fi
echo "Switched to: $THEME"
PID=$(ps -ax -o pid,command | grep "ghostty$" | grep -v grep | awk '{print $1}')
if [[ -n "$PID" ]]; then
    kill -USR2 "$PID" 2>/dev/null || echo "Could not reload Ghostty config"
else
    echo "Could not find Ghostty process"
fi