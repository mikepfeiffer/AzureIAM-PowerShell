# ===================================================================
# Bulk Provisioning from CSV
# ===================================================================

$users = Import-Csv -Path "./users.csv"

foreach ($user in $users) {
    $passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $passwordProfile.Password = $user.Password

    $userParams = @{
        DisplayName       = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        MailNickName      = $user.MailNickName
        AccountEnabled    = $true
        PasswordProfile   = $passwordProfile
    }

    New-EntraUser @userParams

}


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
