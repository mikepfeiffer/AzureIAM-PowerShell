# Requires: Az.Accounts + Az.Resources
# Connect-AzAccount

$subscriptionId = (Get-AzContext).Subscription.Id

# Custom role definition as a hashtable (we'll export to JSON)
$role = @{
    Name             = "VM Lifecycle Operator"
    IsCustom         = $true
    Description      = "Can view VMs and perform lifecycle operations (start/stop/restart/deallocate). No write/delete."
    Actions          = @(
        # Read VM and related status
        "Microsoft.Compute/virtualMachines/read",
        "Microsoft.Compute/virtualMachines/instanceView/read",

        # Lifecycle operations
        "Microsoft.Compute/virtualMachines/start/action",
        "Microsoft.Compute/virtualMachines/powerOff/action",
        "Microsoft.Compute/virtualMachines/restart/action",
        "Microsoft.Compute/virtualMachines/deallocate/action"
    )
    NotActions       = @(
        # Optional explicit blocks (usually not required because we didn't grant writes),
        # but can be useful for clarity if you later expand actions.
        "Microsoft.Compute/virtualMachines/delete",
        "Microsoft.Compute/virtualMachines/write"
    )
    DataActions      = @()
    NotDataActions   = @()
    AssignableScopes = @(
        "/subscriptions/$subscriptionId"
        # If you want *only* one RG to be eligible for assignments, use this instead:
        # "/subscriptions/$subscriptionId/resourceGroups/$rgName"
    )
}

# Write role JSON to a temp file
$tempPath = ".\vm-lifecycle-operator-role.json"
$role | ConvertTo-Json -Depth 10 | Out-File -FilePath $tempPath -Encoding utf8  

# Create the custom role
New-AzRoleDefinition -InputFile $tempPath

Write-Host "Created custom role: VM Lifecycle Operator"

# Example: assign to a user at Resource Group scope
$rgName = "lab-4089"
$scope  = "/subscriptions/$subscriptionId/resourceGroups/$rgName"

# Find a user (or service principal) to assign to
$userUpn = "john@sandboxlabs.net"
$user    = Get-AzADUser -UserPrincipalName $userUpn

New-AzRoleAssignment `
  -ObjectId $user.Id `
  -RoleDefinitionName "VM Lifecycle Operator" `
  -Scope $scope
