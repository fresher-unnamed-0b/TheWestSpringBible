# Define the URL of the wallpaper image
$wallpaperUrl = "<WALLPAPER URL HERE>"

# Define the local path to save the image
$wallpaperPath = "C:\WestSpring IT\MicrosoftIntune\desktop-wallpaper.jpeg"

# Ensure the directory exists, create it if it doesn't
if (!(Test-Path -Path "C:\WestSpring IT\MicrosoftIntune")) {
    New-Item -ItemType Directory -Path "C:\WestSpring IT\MicrosoftIntune" -Force
}

# Download the wallpaper image
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath

# Define the registry key for the wallpaper setting
$wallpaperRegistryKey = "HKCU:\Control Panel\Desktop"

# Update the registry to set the downloaded image as wallpaper
Set-ItemProperty -Path $wallpaperRegistryKey -Name Wallpaper -Value $wallpaperPath

# Refresh the desktop to apply the wallpaper
RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters ,1 ,True