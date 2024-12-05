# Connect to Exchange Online
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

# Get all accepted domains
$acceptedDomains = Get-AcceptedDomain

foreach ($domain in $acceptedDomains) {
    $domainName = $domain.DomainName

    # Skip domains ending with ".onmicrosoft.com" or "excl.cloud"
    if (-not ($domainName -like "*.onmicrosoft.com" -or $domainName -like "*.excl.cloud")) {
        # Create shared mailbox for RUA DMARC reports
        $ruaMailboxName = "dmarc-rua-$($domainName.Replace('.', '-'))"
        New-Mailbox -Shared -Name "DMARC Aggregate | $domainName" -PrimarySmtpAddress "$ruaMailboxName@$domainName" -DisplayName "DMARC Aggregate | $domainName"

        # Create shared mailbox for RUF DMARC reports
        $rufMailboxName = "dmarc-ruf-$($domainName.Replace('.', '-'))"
        New-Mailbox -Shared -Name "DMARC Forensic | $domainName" -PrimarySmtpAddress "$rufMailboxName@$domainName" -DisplayName "DMARC Forensic | $domainName"

        # Generate DMARC TXT record
        $dmarcRecord = "v=DMARC1; p=reject; rua=mailto:$ruaMailboxName@$domainName; ruf=mailto:$rufMailboxName@$domainName; fo=1; pct=100; ri=86400; adkim=s; aspf=s"
        Write-Output "DMARC TXT record for $($domainName):"
        Write-Output $dmarcRecord
        Write-Output "=" * 50
    }
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false