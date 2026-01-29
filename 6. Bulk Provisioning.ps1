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