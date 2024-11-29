<# Prior to running this, export all tenants from Microsoft Lighthouse by navigating to https://lighthouse.microsoft.com, selecting "Tenants" on the blade on the left, followed by "Export" at the top of the client list. Un-comment the module that you wish to connect to. #>

$tenants = Import-Csv -Path "<PATH TO CSV>"
foreach ($tenant in $tenants) {
    $tenantDomain = $row."Tenant Domain"
    $tenantId = $row."Tenant ID"
    # Connect-ExchangeOnline -Organization $tenant.tenantDomain
    # Connect-AzureAD -TenantId $tenant.tenantId
    # Connect-MicrosoftTeams -TenantId $tenant.tenantId
    try {
        # <INSERT LOGIC HERE>
    }
    catch {
        Write-Host "Error processing: $_" -ForegroundColor Red
    }
}