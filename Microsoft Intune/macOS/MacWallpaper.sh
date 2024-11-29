#!/bin/bash

# Define the URL of the wallpaper
wallpaperURL="<WALLPAPER URL HERE>"

# Define the path to save the wallpaper in /Users/Shared
wallpaperPath="/Users/Shared/WestSpring IT/MicrosoftIntune/desktop-wallpaper.jpeg"

# Download the wallpaper
curl -o "$wallpaperPath" "$wallpaperURL"

# Set the desktop wallpaper
osascript -e "tell application \"System Events\" to set picture of every desktop to \"$wallpaperPath\""