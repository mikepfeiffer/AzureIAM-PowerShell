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