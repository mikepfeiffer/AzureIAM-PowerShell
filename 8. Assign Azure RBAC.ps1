# ===================================================================
# Demo: Assign Azure RBAC role with Az PowerShell
#
# Purpose:
# - Show how to grant access to an Azure scope using Azure RBAC
# - Assign a built-in role (Reader/Contributor/etc.) to a user
#
# Prerequisites:
# - You are authenticated to Azure (Cloud Shell is already authenticated)
# - You have permissions to create role assignments at the target scope
# ===================================================================


# -------------------------------------------------------------------
# 1) Set demo variables
#
# - Scope: where the permission applies (subscription/RG/resource)
# - Principal: who gets access (user, group, service principal, managed identity)
# - Role: what they can do (Reader, Contributor, etc.)
# -------------------------------------------------------------------
$subscriptionId     = (Get-AzContext).Subscription.Id
$resourceGroupName  = 'core-infrastructure'     # <-- change as needed
$userUpn            = 'ralph@sandboxlabs.net'   # <-- change as needed
$roleName           = 'Reader'                  # Reader | Contributor | etc.

$scope = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"


# -------------------------------------------------------------------
# 2) Resolve the user to an Azure AD / Entra object id
#
# New-AzRoleAssignment expects the principal's ObjectId.
# Get-AzADUser queries Entra ID through Az and returns the Id.
# -------------------------------------------------------------------
$user = Get-AzADUser -UserPrincipalName $userUpn
if (-not $user) { throw "User not found in Entra ID: $userUpn" }

$principalObjectId = $user.Id


# -------------------------------------------------------------------
# 3) Create the RBAC role assignment
#
# This grants the user the specified role at the given scope.
# Azure RBAC is enforced by Azure Resource Manager (ARM).
# -------------------------------------------------------------------
New-AzRoleAssignment `
  -ObjectId $principalObjectId `
  -RoleDefinitionName $roleName `
  -Scope $scope


# -------------------------------------------------------------------
# 4) Verify the assignment (show a readable result)
# -------------------------------------------------------------------
Get-AzRoleAssignment `
  -ObjectId $principalObjectId `
  -Scope $scope |
Select-Object RoleDefinitionName, DisplayName, SignInName, Scope |
Format-Table -AutoSize
