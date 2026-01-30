# ===================================================================
# Create a new group
# ===================================================================

Connect-Entra -Scopes 'Group.ReadWrite.All'

$groupParams = @{
    DisplayName = 'Sandboxlabs marketing'
    MailEnabled = $false
    SecurityEnabled = $true
    MailNickName = 'NotSet'
}
New-EntraGroup @groupParams


# ===================================================================
# Add user to a group
# ===================================================================


$group = Get-EntraGroup -Filter "displayName eq 'Sandboxlabs marketing'"
$user = Get-EntraUser -UserId 'ralph@sandboxlabs.net'
Add-EntraGroupMember -GroupId $group.Id -MemberId $user.Id

