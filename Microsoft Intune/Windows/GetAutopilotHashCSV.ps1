<# This script needs to ran using elevated privileges.  #>

# Set the execution policy to allow running scripts
Set-ExecutionPolicy RemoteSigned

# Check if Get-WindowsAutoPilotInfo is installed and install if not present
try {
    if (!(Get-InstalledScript -Name Get-WindowsAutoPilotInfo -ErrorAction SilentlyContinue)) {
        Install-Script Get-WindowsAutoPilotInfo -Force
    }
} catch {
    Write-Host "Failed to install Get-WindowsAutoPilotInfo script: $_" -ForegroundColor Red
    return
}

# Retrieve the serial number of the machine
$serialNumber = (Get-WmiObject -Class Win32_BIOS).SerialNumber

# Generate the AutoPilot information and save it to a CSV file named after the serial number
try {
    Get-WindowsAutoPilotInfo -OutputFile "C:\WestSpring IT\MicrosoftIntune\$serialNumber.csv"
    Write-Host "Successfully exported Autopilot hash for $serialNumber" -ForegroundColor Green
} catch {
    Write-Error "Failed to generate or save AutoPilot information: $_"
    exit 1
}
