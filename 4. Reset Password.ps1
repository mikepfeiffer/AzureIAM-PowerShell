# ===================================================================
# Reset Password
# ===================================================================

Connect-Entra -Scopes 'User.ReadWrite.All', 'Group.ReadWrite.All', 'Directory.AccessAsUser.All'
$securePassword = ConvertTo-SecureString 'Q8!vN2#pL7@xR5$kT9^m' -AsPlainText -Force

Set-EntraUserPasswordProfile -ObjectId 'ralph@sandboxlabs.net' -Password $securePassword


# -------------------------------------------------------------------
# NOTE: Hybrid Password Reset Behavior
#
# In hybrid environments (on-prem AD synced to Entra ID), password
# authority remains on-premises.
#
# When Self-Service Password Reset (SSPR) is enabled, password
# writeback is configured, and users are properly licensed (P1/P2),
# AD-sourced users can reset their passwords in the cloud and have
# those changes written back to on-prem Active Directory.
#
# This script demonstrates cloud-based password reset behavior.
# Always ensure your tenant’s SSPR scope, licensing, and writeback
# configuration align with your identity source-of-authority model.
# -------------------------------------------------------------------
