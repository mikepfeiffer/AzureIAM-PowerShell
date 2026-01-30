# ===================================================================
# Demo: Assign an Entra ID directory role to a user
#
# This script demonstrates how to assign an Entra ID (directory)
# role such as User Administrator or Groups Administrator.
#
# Notes:
# - Entra roles apply at the DIRECTORY level
# - This is NOT Azure RBAC
# - Uses Microsoft.Entra PowerShell (Graph-based)
# ===================================================================


$userUpn  = 'ralph@sandboxlabs.net'
$roleName = 'User Administrator'

# Get the user
$user = Get-EntraUser -UserId $userUpn

# Get the role definition
$role = Get-EntraDirectoryRoleDefinition |
    Where-Object { $_.DisplayName -eq $roleName }

# Assign the role
New-EntraDirectoryRoleAssignment `
    -PrincipalId      $user.Id `
    -RoleDefinitionId $role.Id `
    -DirectoryScopeId '/'

# Verify assignment
Get-EntraDirectoryRoleAssignment |
    Where-Object { $_.PrincipalId -eq $user.Id } |
    Select-Object PrincipalId, RoleDefinitionId |
    Format-Table -AutoSize
    

# ===================================================================
# Entra ID Directory Role Assignment Report (Readable Table)
#
# Shows:
# - Role name
# - Who it's assigned to (user/group/service principal)
# - Principal type
# - Scope (Tenant vs specific scope)
#
# Prereq:
#   Connect-Entra -Scopes 'Directory.Read.All'
# ===================================================================

# Connect to Entra ID using a scope that allows us to read from the tenant/directory

Connect-Entra -Scopes 'Directory.Read.All'

# Get role assignments
$assignments = Get-EntraDirectoryRoleAssignment -All

# Cache role definitions (id -> display name)
$roleDefinitions = Get-EntraDirectoryRoleDefinition -All |
    Group-Object -Property Id -AsHashTable

# Cache principals (principalId -> resolved object)
$principalCache = @{}

$report = foreach ($assignment in $assignments) {

    # Resolve role name from RoleDefinitionId
    $roleName = $roleDefinitions[$assignment.RoleDefinitionId].DisplayName

    # Resolve principal (cached)
    if (-not $principalCache.ContainsKey($assignment.PrincipalId)) {
        $principalCache[$assignment.PrincipalId] = Get-EntraDirectoryObject -ObjectId $assignment.PrincipalId
    }
    $principal = $principalCache[$assignment.PrincipalId]

    # Determine principal type + display name
    switch ($principal.'@odata.type') {
        '#microsoft.graph.user' {
            $assignedTo    = $principal.DisplayName
            $principalType = 'User'
        }
        '#microsoft.graph.group' {
            $assignedTo    = $principal.DisplayName
            $principalType = 'Group'
        }
        '#microsoft.graph.servicePrincipal' {
            $assignedTo    = $principal.DisplayName
            $principalType = 'ServicePrincipal'
        }
        default {
            $assignedTo    = $assignment.PrincipalId
            $principalType = 'Unknown'
        }
    }

    # Normalize scope
    $scope = if ($assignment.DirectoryScopeId -eq '/' -or [string]::IsNullOrEmpty($assignment.DirectoryScopeId)) {
        'Tenant'
    } else {
        $assignment.DirectoryScopeId
    }

    # Emit one row
    [pscustomobject]@{
        RoleName       = $roleName
        AssignedTo     = $assignedTo
        PrincipalType  = $principalType
        Scope          = $scope
    }
}

# Output a clean table
$report | Sort-Object RoleName, AssignedTo | Format-Table -AutoSize
