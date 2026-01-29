# ===================================================================
# Demo 1: Microsoft Entra PowerShell setup in Azure Cloud Shell
#
# Environment:
# - Visual Studio Code
# - Azure Resources extension
# - Azure Cloud Shell (PowerShell) running in the VS Code terminal
#
# Purpose:
# - Prepare a PowerShell session for Microsoft Entra ID
#   (formerly Azure Active Directory) IAM automation
# ===================================================================


# -------------------------------------------------------------------
# Install the Microsoft.Entra PowerShell module
# https://learn.microsoft.com/en-us/powershell/entra-powershell/
#
# Microsoft.Entra is the modern PowerShell module for managing
# Microsoft Entra ID resources such as:
# - Users
# - Groups
# - Applications
# - Service principals
#
# It is built on Microsoft Graph and replaces the deprecated
# AzureAD and MSOnline modules.
#
# Installation notes:
# - Installed from the PowerShell Gallery
# - Installed to the CurrentUser scope so no admin rights are required
# - Stored in the Cloud Shell home directory, so it persists
#   across Cloud Shell sessions
# -------------------------------------------------------------------


Install-Module `
    -Name Microsoft.Entra `
    -Repository PSGallery `
    -Scope CurrentUser `
    -Force `
    -AllowClobber


# -------------------------------------------------------------------
# Connect to Microsoft Entra ID
#
# Connect-Entra authenticates this PowerShell session using
# Microsoft Graph under the hood.
#
# Unlike older Azure AD modules, Graph requires explicit OAuth scopes
# to define what this session is allowed to do.
#
# Requested scopes for this demo:
# - User.ReadWrite.All
#     Allows full read/write access to users in the directory
#
# - Group.ReadWrite.All
#     Allows full read/write access to groups and group membership
#
# These delegated permissions support common IAM automation scenarios
# such as:
# - Creating and updating users
# - Creating security or Microsoft 365 groups
# - Managing group membership
#
# Note:
# - Admin consent is required for these scopes
# - Consent is prompted the first time if not already granted
# -------------------------------------------------------------------


Connect-Entra -Scopes 'User.ReadWrite.All', 'Group.ReadWrite.All'


# -------------------------------------------------------------------
# At this point, the PowerShell session is:
# - Authenticated to Microsoft Entra ID
# - Authorized via Microsoft Graph using delegated permissions
# -------------------------------------------------------------------




