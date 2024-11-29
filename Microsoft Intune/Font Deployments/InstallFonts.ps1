# Load System.Drawing assembly
Add-Type -AssemblyName System.Drawing

# Define the path to the fonts folder
$fontsFolder = Join-Path -Path $PSScriptRoot -ChildPath "fonts"

# Get all font files in the fonts folder
$fontFiles = Get-ChildItem -Path $fontsFolder -Filter "*.ttf" -File

foreach ($fontFile in $fontFiles) {
    # Copy the font file to the Fonts directory
    $destinationPath = "C:\Windows\Fonts\$($fontFile.Name)"
    Copy-Item -Path $fontFile.FullName -Destination $destinationPath -Force
    
    # Register the font in the system
    $fontCollection = New-Object System.Drawing.Text.PrivateFontCollection
    $fontCollection.AddFontFile($destinationPath)
}
