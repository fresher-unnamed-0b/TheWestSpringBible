#!/bin/bash

WALLPAPER_PATH="/Users/Shared/WestSpring IT/MicrosoftIntune/desktop-wallpaper.jpeg"
WALLPAPER_URL="https://westspringit.blob.core.windows.net/intune-content/desktop-wallpaper.jpeg"

if [[ ! -f "$WALLPAPER_PATH" ]]; then
    mkdir -p "$(dirname "$WALLPAPER_PATH")"
    curl -s -L -o "$WALLPAPER_PATH" "$WALLPAPER_URL"
    if [[ $? -ne 0 ]]; then
        exit 1
    fi
fi

osascript -e 'tell application "System Events" to set picture of every desktop to "'"$WALLPAPER_PATH"'"'
exit 0
