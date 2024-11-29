# Define the registry key path and value
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MfaRequiredInClipRenew"
$registryValueName = "Verify Multifactor Authentication in ClipRenew"
$registryValueData = 0  # DWORD value of 0
$sid = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-4")  # SID for interactive group

# Check if the registry key already exists
if (-not (Test-Path -Path $registryPath)) {
    # If the key doesn't exist, create it and set the DWORD value
    New-Item -Path $registryPath -Force | Out-Null
    Set-ItemProperty -Path $registryPath -Name $registryValueName -Value $registryValueData -Type DWORD
}

# Add read permissions for the Interactive group to the registry key
$acl = Get-Acl -Path $registryPath
$ruleSID = New-Object System.Security.AccessControl.RegistryAccessRule($sid, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($ruleSID)
Set-Acl -Path $registryPath -AclObject $acl

# Start the scheduled task
Get-ScheduledTask -TaskName 'LicenseAcquisition' | Start-ScheduledTask