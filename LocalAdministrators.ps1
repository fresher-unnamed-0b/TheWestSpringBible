<# When modifying this script for use for a new client, only update the values within the @admins array directly below this comment. 

Please don't modify other lines of code unless you know what you're doing. 

This script should be deployed through AteraRMM, set to run at 12:00 PM every Monday.

#>

$admins = @(
    @{ Name = "wsadmin"; Password = "<PASSWORD>" },
    @{ Name = "<CLIENTADMIN>"; Password = "<PASSWORD>" }
)

Write-Host "[START] Starting local admin account setup" -ForegroundColor Cyan

foreach ($admin in $admins) {
    try {
        # Convert provided password to a secure string
        $securePassword = ConvertTo-SecureString $admin.Password -AsPlainText -Force

        # Check account exists, create if not
        if (-not (Get-LocalUser -Name $admin.Name -ErrorAction SilentlyContinue)) {
            Write-Host "[INFO] Account $($admin.Name) does not exist" -ForegroundColor Yellow
            Write-Host "[INFO] Creating account $($admin.Name) with provided password" -ForegroundColor Yellow
            # Create the local user account
            $userParams = @{
                Name     = $admin.Name
                Password = $securePassword
            }
            New-LocalUser @userParams
            Write-Host "[SUCCESS] Created $($admin.Name)" -ForegroundColor Green
        }
        else {
            # User does exist, align password
            Write-Host "[INFO] Account $($admin.Name) already exists" -ForegroundColor Yellow
            Write-Host "[INFO] Updating password for $($admin.Name)" -ForegroundColor Yellow
            Set-LocalUser -Name $admin.Name -Password $securePassword
            Write-Host "[SUCCESS] Password updated for $($admin.Name)" -ForegroundColor Green
        }

        # Set password never expires
        Set-LocalUser -Name $admin.Name -PasswordNeverExpires $true
        Write-Host "[SUCCESS] Set password never expires for $($admin.Name)" -ForegroundColor Green

        # Add to Administrators only if not already a member
        $adminGroupMembers = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue
        $alreadyMember = $false
        foreach ($member in $adminGroupMembers) {
            # Name typically like "MACHINE\\wsadmin"; match the tail
            if ($member.Name -match "\\$($admin.Name)$") {
                $alreadyMember = $true
                break 
            }
        }

        if (-not $alreadyMember) {
            # Add user to Administrators group
            Write-Host "[INFO] Account $($admin.Name) is not in Administrators group" -ForegroundColor Yellow
            Add-LocalGroupMember -Group "Administrators" -Member $admin.Name
            Write-Host "[SUCCESS] Added $($admin.Name) to Administrators" -ForegroundColor Green
        }
        else {
            # Already a member, no action needed
            Write-Host "[INFO] $($admin.Name) already in Administrators" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "[ERROR] $($admin.Name): $($_.Exception.Message)" -ForegroundColor Red
        # Continue to next admin
    }
}

Write-Host "[END] Local admin account setup completed" -ForegroundColor Cyan
