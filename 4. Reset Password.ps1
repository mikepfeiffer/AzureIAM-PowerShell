# ===================================================================
# Reset Password
# ===================================================================

Connect-Entra -Scopes 'User.ReadWrite.All', 'Group.ReadWrite.All', 'Directory.AccessAsUser.All'
$securePassword = ConvertTo-SecureString 'Q8!vN2#pL7@xR5$kT9^m' -AsPlainText -Force
Set-EntraUserPasswordProfile -ObjectId 'ralph@sandboxlabs.net' -Password $securePassword