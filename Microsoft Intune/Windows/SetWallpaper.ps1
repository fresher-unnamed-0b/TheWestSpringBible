# Define the URL of the wallpaper image
$wallpaperUrl = "<WALLPAPER URL HERE>"

# Define the local path to save the image
$wallpaperPath = "C:\WestSpring IT\MicrosoftIntune\desktop-wallpaper.jpeg"

# Ensure the directory exists, create it if it doesn't
$directoryPath = "C:\WestSpring IT\MicrosoftIntune"
if (!(Test-Path -Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath -Force
}

# Download the wallpaper image
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath

# Define the registry key for the wallpaper setting
$wallpaperRegistryKey = "HKCU:\Control Panel\Desktop"

# Update the registry to set the downloaded image as wallpaper
Set-ItemProperty -Path $wallpaperRegistryKey -Name Wallpaper -Value $wallpaperPath

# Set the wallpaper style (0 = Centered, 2 = Stretched, 6 = Fit, 10 = Fill)
Set-ItemProperty -Path $wallpaperRegistryKey -Name WallpaperStyle -Value 2  # Change to your preferred style

# Refresh the desktop to apply the wallpaper
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
