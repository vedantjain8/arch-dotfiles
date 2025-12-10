#!/bin/bash

# --- Wallpapers directory (use $HOME/Drive as base) ---
WALL_DIR="$HOME/Drive/wallpaper/macos"

# --- Determine current hour (00..23) and build filename ---
CURRENT_HOUR=$(date +%H)
HH=$(printf "%02d" $((10#$CURRENT_HOUR)))
WALLPAPER_PATH="$WALL_DIR/${HH}.jpg"

# --- Execute Hyprlock with the selected wallpaper ---
HYPRLOCK_WALL="$WALLPAPER_PATH" hyprlock
exit 0