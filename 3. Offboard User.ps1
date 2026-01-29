# ===================================================================
# 1. Disable user
# ===================================================================

Set-EntraUser -UserId 'ralph@sandboxlabs.net' -AccountEnabled $false

# ===================================================================
# 2. Remove user account
# ===================================================================

Remove-EntraUser -UserId 'ralph@sandboxlabs.net'

# ===================================================================
# 3. Remove device ownership
# ===================================================================

Connect-Entra -Scopes 'Directory.AccessAsUser.All'
$device = Get-EntraDevice -Filter "DisplayName eq 'Ralph Miller'"
$owner = Get-EntraDeviceRegisteredOwner -DeviceId $device.Id
Remove-EntraDeviceRegisteredOwner -DeviceId $device.Id -OwnerId $owner.Id