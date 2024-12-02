# Load necessary assemblies
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class FontRegister {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern bool AddFontResource(string lpFileName);
}
"@

# Define the path to the fonts folder
$fontsFolder = Join-Path -Path $PSScriptRoot -ChildPath "fonts"

# Get all font files in the fonts folder
$fontFiles = Get-ChildItem -Path $fontsFolder -Filter "*.ttf" -File

foreach ($fontFile in $fontFiles) {
    # Define the destination path in the Windows Fonts directory
    $destinationPath = "C:\Windows\Fonts\$($fontFile.Name)"
    
    # Copy the font file to the Fonts directory
    Copy-Item -Path $fontFile.FullName -Destination $destinationPath -Force

    # Register the font with the system (use AddFontResource from user32.dll)
    [FontRegister]::AddFontResource($destinationPath)
}

# Refresh the font cache (optional, but ensures the font is available immediately)
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class RefreshFont {
    [DllImport("gdi32.dll")]
    public static extern int AddFontResourceEx(string lpszFilename, uint fl, IntPtr pdv);
}
"@

# Refresh the font cache
foreach ($fontFile in $fontFiles) {
    [RefreshFont]::AddFontResourceEx($fontFile.FullName, 0x10, [IntPtr]::Zero)
}

Write-Host "Fonts installed and registered successfully!"
