<# This script assumes you have already connected to Exchange Online within PowerShell. #>

$acceptedDomains = Get-AcceptedDomain

# Function to lookup nameservers (NS) for the domain
function Get-DNSHost {
    param (
        [string]$Domain
    )
    
    try {
        # Query DNS for the authoritative nameservers (NS records)
        $nameServers = Resolve-DnsName -Name $domain -Type NS
        
        # Extract and return nameserver names
        $nameServers | Select-Object -ExpandProperty NameHost
    } catch {
        Write-Host "Failed to lookup nameservers for $domain"
        return $null
    }
}

# Loop through each accepted domain
foreach ($domain in $acceptedDomains) {
    # Check if the domain is not the default .onmicrosoft.com domain and does not end with excl.cloud
    if (-not ($domain.Name.EndsWith(".onmicrosoft.com")) -and -not ($domain.Name.EndsWith("excl.cloud"))) {
        # Create a shared mailbox for DMARC aggregate reports
        New-Mailbox -Shared -Name "DMARC Aggregate | $($domain.Name)" -DisplayName "DMARC Aggregate | $($domain.Name)" -PrimarySmtpAddress "dmarc-rua@$($domain.Name)" -Alias "dmarc-rua"
        
        # Create a shared mailbox for DMARC forensic reports
        New-Mailbox -Shared -Name "DMARC Forensic | $($domain.Name)" -DisplayName "DMARC Forensic | $($domain.Name)" -PrimarySmtpAddress "dmarc-ruf@$($domain.Name)" -Alias "dmarc-ruf"

        # Generate the DMARC record text
        $dmarcRecord = "v=DMARC1; p=reject; rua=mailto:dmarc-rua@$($domain.Name); ruf=mailto:dmarc-ruf@$($domain.Name); fo=1; pct=100; ri=86400; adkim=s; aspf=s"

        Write-Host ("=" * 80)
        Write-Host ""
        
        # Output the DMARC record
        Write-Host "DMARC Record for $($domain.Name):"
        Write-Host $dmarcRecord
        Write-Host ""

        # Lookup nameservers (NS) for the domain
        $nameServers = Get-DNSHost -Domain $domain.Name
        if ($nameServers) {
            Write-Host "DNS Hosts for $($domain.Name):"
            $nameServers | ForEach-Object { Write-Host $_ }
            Write-Host ""
        }

        Write-Host ("=" * 80)
    }
}
