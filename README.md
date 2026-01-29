# AzureIAM-PowerShell

This repository contains the **PowerShell demo scripts** used in StormWind’s webinar:

**PowerShell for Azure Identity & Access Management**  
https://sales.stormwindstudios.com/powershell-for-azure-identity

The scripts are designed for **sysadmins and CloudOps engineers** who want practical, real-world examples of managing **Microsoft Entra ID (Azure AD)** and **Azure RBAC** using modern PowerShell tooling.

---

## What You’ll Learn from the Webinar

The webinar focuses on **hands-on identity and access management tasks** using PowerShell, with an emphasis on:

- The difference between **Entra ID roles** and **Azure RBAC**
- When to use **Microsoft.Entra PowerShell (Graph-based)** vs **Az PowerShell**
- How delegated permissions and scopes affect what scripts can do
- How to automate common IAM operational workflows safely and repeatably

This repo mirrors that flow, starting with setup and moving through common lifecycle and reporting scenarios.

---

## Repository Structure & Script Overview

The scripts are numbered in the **same order they are demonstrated** in the session.

### 1. Setup.ps1
Initial environment setup:
- Installs required modules
- Connects to Microsoft Entra ID using `Connect-Entra`
- Explains required Graph scopes and why they matter

---

### Entra ID (Identity) Automation

These scripts use the **Microsoft.Entra PowerShell module**, which is built on Microsoft Graph.

- **2. Onboard User.ps1**  
  Create a new Entra ID user using PowerShell.

- **3. Offboard User.ps1**  
  Disable or remove a user as part of an offboarding workflow.

- **4. Reset Password.ps1**  
  Reset a user password and demonstrate how Entra password policies affect automation.

- **5. Group Management.ps1**  
  Create groups and manage group membership.

- **6. Bulk Provisioning.ps1**  
  Simple bulk user creation from CSV.

- **7. Bulk Provisioning Advanced.ps1**  
  Extended bulk provisioning patterns with additional logic and validation.

---

### Azure RBAC (Resource Access)

These scripts use **Az PowerShell** and focus on Azure Resource Manager–level access.

- **8. Assign Azure RBAC.ps1**  
  Assign an Azure RBAC role (Reader, Contributor, etc.) to a user at a defined scope (subscription or resource group).

- **10. Custom RBAC Role.ps1**  
  Demonstrates creating and working with custom Azure RBAC roles.

---

### Reporting & Visibility

- **9. Entra Role Assignment Report.ps1**  
  Generates a readable report showing:
  - Entra role name  
  - Who the role is assigned to (user, group, service principal)  
  - Scope  

  This script highlights how raw Graph IDs are resolved into human-readable output for auditing and review.

---

## Intended Audience

This repo is intended for:

- System administrators
- CloudOps / DevOps engineers
- Azure administrators
- Anyone responsible for **identity, access, and permissions** in Azure

The scripts favor **clarity over cleverness** and are meant to be:
- Readable
- Easy to modify
- Safe to run in demo or lab environments

---

## Notes

- Scripts assume execution from **Azure Cloud Shell (PowerShell)** or a local PowerShell 7 environment.
- Permissions are intentionally explicit to reinforce **least privilege** concepts.
- Passwords and secrets in scripts are for **demo purposes only**.

---

## Open Source & Disclaimer

This repository is provided as **open-source example code** under the MIT License.

The scripts are intended for **educational and demonstration purposes only**.  
They are not production-hardened and may require additional validation, error handling, and security controls before use in live environments.

By using this code, you acknowledge that:
- You are responsible for reviewing, testing, and validating the scripts in your own environment
- StormWind Studios and the author assume **no liability** for how the code is used or modified
- Identity- and access-related scripts should be executed with care, especially in production tenants

Always follow your organization’s security, compliance, and change-management practices when working with identity and access controls.

---

## License

MIT License
