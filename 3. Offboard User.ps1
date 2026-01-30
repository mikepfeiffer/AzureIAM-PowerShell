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


$device = Get-EntraDevice -Filter "DisplayName eq 'Ralph Miller'"
$owner = Get-EntraDeviceRegisteredOwner -DeviceId $device.Id

Remove-EntraDeviceRegisteredOwner -DeviceId $device.Id -OwnerId $owner.Id


# -------------------------------------------------------------------
# NOTE: Hybrid Offboarding Considerations
#
# In hybrid environments, Microsoft Entra ID acts as the control plane
# for cloud access, while on-prem Active Directory remains the system
# of record for user and device lifecycle.
#
# For AD-synced users and devices, offboarding should typically begin
# on-prem (disable or delete), then allow those changes to synchronize
# to Entra ID.
#
# Entra ID–based offboarding actions are best suited for:
# - Cloud-only users and devices
# - Revoking cloud access (sessions, apps, licenses)
# - Intune and Conditional Access cleanup
#
# Always follow your organization’s identity source-of-authority model
# when offboarding users in hybrid environments.
# -------------------------------------------------------------------
