# Check if the Exchange Online Management module is installed
Write-Host "Checking for Exchange Online Management module..."
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Host "Exchange Online Management module not found. Installing..." -ForegroundColor Yellow
    try {
        Install-Module -Name ExchangeOnlineManagement -Force -Scope CurrentUser -ErrorAction Stop
        Write-Host "Exchange Online Management module installed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to install Exchange Online Management module. Exiting script." -ForegroundColor Red
        return
    }
} else {
    Write-Host "Exchange Online Management module is already installed." -ForegroundColor Green
}

# Import the module
Import-Module ExchangeOnlineManagement

# Prompt for the leaver's email address
$emailAddress = Read-Host -Prompt "Enter the leaver's email address (e.g., user@domain.com)"
if (-not $emailAddress -or -not $emailAddress.Contains("@")) {
    Write-Host "Invalid email address provided. Exiting script." -ForegroundColor Red
    return
}

# Split the email address into username and domain
$userName = $emailAddress.Split("@")[0]
$domainName = $emailAddress.Split("@")[1]

Write-Host "Username: $userName"
Write-Host "Domain: $domainName"

# Connect to Exchange Online using the extracted domain name
Write-Host "Connecting to Exchange Online for domain: $domainName..."
try {
    Connect-ExchangeOnline -Organization $domainName -ErrorAction Stop
    Write-Host "Connected to Exchange Online successfully for domain: $domainName." -ForegroundColor Green
} catch {
    Write-Host "Failed to connect to Exchange Online for domain: $domainName. Exiting script." -ForegroundColor Red
    return
}

# Process Full Access Rights
Write-Host "Processing Full Access Rights..."
try {
    $mailboxes = Get-Mailbox | Get-MailboxPermission -User $userName
    if ($mailboxes) {
        Write-Host "Removing Full Access Rights..."
        foreach ($mailbox in $mailboxes) {
            Remove-MailboxPermission -Identity $mailbox.Identity -AccessRights FullAccess -User $userName -Confirm:$false
        }
    } else {
        Write-Host "No Full Access rights found for user $userName."
    }
} catch {
    Write-Host "Error processing Full Access Rights: $_" -ForegroundColor Red
}

# Process SendAs Rights
Write-Host "Processing SendAs Rights..."
try {
    $sendAsMailboxes = Get-Mailbox -ResultSize Unlimited | Get-RecipientPermission | Where-Object { $_.Trustee -eq $emailAddress }
    if ($sendAsMailboxes) {
        Write-Host "Removing SendAs Rights..."
        foreach ($mailbox in $sendAsMailboxes) {
            Remove-RecipientPermission -Identity $mailbox.Identity -AccessRights SendAs -Trustee $emailAddress -Confirm:$false
        }
    } else {
        Write-Host "No SendAs rights found for user $userName."
    }
} catch {
    Write-Host "Error processing SendAs Rights: $_" -ForegroundColor Red
}

# Process SendOnBehalf Rights
Write-Host "Processing SendOnBehalf Rights..."
try {
    $sendOnBehalfMailboxes = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.GrantSendOnBehalfTo -match $userName }
    if ($sendOnBehalfMailboxes) {
        Write-Host "Removing SendOnBehalf Rights..."
        foreach ($mailbox in $sendOnBehalfMailboxes) {
            Set-Mailbox -Identity $mailbox.Alias -GrantSendOnBehalfTo @{remove=$emailAddress} -Confirm:$false
        }
    } else {
        Write-Host "No SendOnBehalf rights found for user $userName."
    }
} catch {
    Write-Host "Error processing SendOnBehalf Rights: $_" -ForegroundColor Red
}

# Remove Calendar Permissions
Write-Host "Processing Calendar Permissions..."
try {
    $userMailboxes = Get-Mailbox
    $mailboxCount = 0
    foreach ($mailbox in $userMailboxes) {
        $mailboxCount++
        Remove-MailboxFolderPermission -Identity "$($mailbox.PrimarySmtpAddress):\Calendar" -User $emailAddress -Confirm:$false -ErrorAction SilentlyContinue
        Write-Progress -Activity 'Processing Users' -CurrentOperation $mailbox.PrimarySmtpAddress -PercentComplete (($mailboxCount / $userMailboxes.Count) * 100)
        Start-Sleep -Milliseconds 200
    }
    Write-Host "Calendar permissions removed successfully." -ForegroundColor Green
} catch {
    Write-Host "Error processing Calendar Permissions: $_" -ForegroundColor Red
}

Write-Host "Script execution completed." -ForegroundColor Green
