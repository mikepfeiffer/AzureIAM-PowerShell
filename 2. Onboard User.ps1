# ===================================================================
# Demo 2: Onboard a new user in Microsoft Entra ID
#
# Prerequisites:
# - Microsoft.Entra PowerShell module installed
# - Active Connect-Entra session
# - Delegated Graph permissions:
#     User.ReadWrite.All
#
# Purpose:
# - Demonstrate how to programmatically create a user account
#   in Microsoft Entra ID using PowerShell
# ===================================================================


$passwordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$passwordProfile.Password = '2oC69}_oX,r['
$userParams = @{
    DisplayName = 'Ralph Miller'
    PasswordProfile = $passwordProfile
    UserPrincipalName = 'ralph@sandboxlabs.net'
    AccountEnabled = $true
    MailNickName = 'ralph'
}

New-EntraUser @userParams


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
