$admins = @(
    @{ Name = "wsadmin"; Password = "<>" },
    @{ Name = "clientadmin"; Password = "<>" }
)

foreach ($admin in $admins) {
    $securePassword = ConvertTo-SecureString $admin.Password -AsPlainText -Force
    if (-not (Get-LocalUser -Name $admin.Name -ErrorAction SilentlyContinue)) {
        $userParams = @{
            Name               = $admin.Name
            Password           = $securePassword
        }
        New-LocalUser @userParams
    }
    else {
        Set-LocalUser -Name $admin.Name -Password $securePassword
    }
    Set-LocalUser -Name $admin.Name -PasswordNeverExpires $true
    Add-LocalGroupMember -Group "Administrators" -Member $admin.Name
}
