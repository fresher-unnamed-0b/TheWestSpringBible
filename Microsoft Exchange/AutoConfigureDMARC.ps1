<# This script assumes you have already connected to Exchange Online within PowerShell. #>

$acceptedDomains = Get-AcceptedDomain

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

        # Output the DMARC record
        Write-Host "DMARC Record for $($domain.Name):"
        Write-Host $dmarcRecord
        Write-Host ""
    }
}
