#!/bin/bash

# --- Define Wallpapers ---
WALL_DIR="$HOME/Drive/wallpaper"
WALL_DAY="$WALL_DIR/daylock.jpeg"
WALL_NIGHT="$WALL_DIR/nightlock.png"

# --- Logic ---
CURRENT_HOUR=$(date +%H)
WALLPAPER_PATH=""

if (( CURRENT_HOUR >= 6 && CURRENT_HOUR < 18 )); then
    # 6:00 to 17:59 (Daytime)
    WALLPAPER_PATH="$WALL_DAY"
else
    # 18:00 to 5:59 (Nighttime)
    WALLPAPER_PATH="$WALL_NIGHT"
fi


# --- Execute Hyprlock with Environment Variable ---
# Set the variable (HYPRLOCK_WALL) and immediately execute hyprlock
# This makes the variable available only to the hyprlock process and its config.
HYPRLOCK_WALL="$WALLPAPER_PATH" hyprlock
