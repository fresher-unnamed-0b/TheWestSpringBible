# Retrieve the status of the AteraAgent service and select its Name and Status properties
$ateraService = Get-Service -Name "AteraAgent" | Select-Object Name, Status

# Get the Duo Authentication installation details using its identifying number
$duoInstallation = Get-WmiObject Win32_Product | Where-Object "identifyingNumber" -Eq "{E18C023C-1FF0-454E-AAF3-2E90139A88D9}"

# Create a hashtable to store the compliance status of Atera RMM Agent and Duo Authentication
$compliance = @{"Atera RMM Agent" = $ateraService.Status; "Duo Authentication" = $duoInstallation.identifyingNumber}

# Convert the compliance hashtable to a JSON string with compressed formatting
$complianceJson = $compliance | ConvertTo-Json -Compress

# Return the JSON string
return $complianceJson
