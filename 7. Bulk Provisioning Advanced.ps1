# ===================================================================
# Bulk Provisioning from CSV Advanced
# ===================================================================

$csvPath    = "./users.csv"
$reportPath = "./provisioning-results.csv"


# -------------------------------------------------------------------
# Password generator
# -------------------------------------------------------------------
$chars = ('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*_-+=').ToCharArray()

function New-DemoPassword {
    param([int]$Length = 24)
    -join (1..$Length | ForEach-Object { $chars | Get-Random })
}

$users = Import-Csv -Path $csvPath

$results = foreach ($u in $users) {

    if ([string]::IsNullOrWhiteSpace($u.DisplayName) -or
        [string]::IsNullOrWhiteSpace($u.UserPrincipalName) -or
        [string]::IsNullOrWhiteSpace($u.MailNickName)) {

        [pscustomobject]@{
            DisplayName       = $u.DisplayName
            UserPrincipalName = $u.UserPrincipalName
            Status            = "Skipped"
            Message           = "Missing required CSV fields (DisplayName, UserPrincipalName, MailNickName)."
            TempPassword      = ""
        }
        continue
    }

    # Generate an initial password candidate
    $newPasswordPlain = New-DemoPassword -Length 24

    # Build a PasswordProfile object (matches the Entra/Graph schema)
    $passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $passwordProfile.Password = $newPasswordPlain

    # Build the parameters for New-EntraUser using splatting
    $userParams = @{
        DisplayName       = $u.DisplayName
        UserPrincipalName = $u.UserPrincipalName
        MailNickName      = $u.MailNickName
        AccountEnabled    = $true
        PasswordProfile   = $passwordProfile
    }

    try {
        # Create the user in Entra ID
        New-EntraUser @userParams -ErrorAction Stop

        # Return success row for the report
        [pscustomobject]@{
            DisplayName       = $u.DisplayName
            UserPrincipalName = $u.UserPrincipalName
            Status            = "Created"
            Message           = "User created successfully."
            TempPassword      = $newPasswordPlain  # demo-only: don't do this in production
        }
    }
    catch {
        # Common failure cases:
        # - UPN already exists
        # - Password rejected by tenant policy
        # - Missing permissions / consent
        [pscustomobject]@{
            DisplayName       = $u.DisplayName
            UserPrincipalName = $u.UserPrincipalName
            Status            = "Failed"
            Message           = $_.Exception.Message
            TempPassword      = ""
        }
    }
}


# -------------------------------------------------------------------
# Export results for demo review / auditing
# -------------------------------------------------------------------
$results | Export-Csv -Path $reportPath -NoTypeInformation

Write-Host "Bulk provisioning complete." -ForegroundColor Green
Write-Host "Input CSV:  $csvPath"
Write-Host "Report CSV: $reportPath"


# -------------------------------------------------------------------
# NOTE: Hybrid Identity Considerations
#
# This script creates cloud-only users in Microsoft Entra ID.
# In hybrid environments where identities are synchronized from
# on-prem Active Directory (Entra Connect / Cloud Sync), user accounts
# should typically be created on-prem first and allowed to sync.
#
# Creating users directly in Entra ID is appropriate for:
# - Cloud-only identities
# - Test or lab environments
# - Scenarios where on-prem AD is not the source of authority
#
# Always follow your organization's identity source-of-authority
# model when provisioning users in hybrid environments.
# -------------------------------------------------------------------

