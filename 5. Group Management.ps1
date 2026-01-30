# ===================================================================
# Create a new group
# ===================================================================


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


# ===================================================================
# Assign an Entra license (example: Entra ID P2) to a security group
# ===================================================================


Import-Module Microsoft.Entra
Connect-Entra -Scopes 'Directory.ReadWrite.All'

# Demo inputs
$groupDisplayName = 'SSPR-P2-Users'
$skuPartNumber   = 'AAD_PREMIUM_P2'

# Get the target group
$group = Get-EntraGroup -Filter "displayName eq '$groupDisplayName'"

# Get the license SKU
$sku = Get-EntraSubscribedSku |
    Where-Object { $_.SkuPartNumber -eq $skuPartNumber }

# Assign the license to the group
Set-EntraGroupLicense `
    -GroupId $group.Id `
    -AddLicenses @(@{ SkuId = $sku.SkuId }) `
    -RemoveLicenses @()

# Verify license assignment on the group
Get-EntraGroup -GroupId $group.Id |
    Select-Object DisplayName, AssignedLicenses |
    Format-List
