# Define the path to the fonts folder
$fontsFolder = Join-Path -Path $PSScriptRoot -ChildPath "fonts"

# Get all font files in the fonts folder
$fontFiles = Get-ChildItem -Path $fontsFolder -Filter "*.ttf" -File

foreach ($fontFile in $fontFiles) {
    # Remove the font file from the Fonts directory
    $destinationPath = "C:\Windows\Fonts\$($fontFile.Name)"
    if (Test-Path -Path $destinationPath) {
        Remove-Item -Path $destinationPath -Force
    }
}
