#PowerShell: Create Resource Group and Assign Owner Permissions to Ralph Kyttle
Login-AzureRmAccount
Select-AzureRmSubscription -Subscription '8879e35e-8084-42db-a948-0fba0108604d'
New-AzureRMResourceGroup -Name 'RBACTest' -Location 'EastUS'
New-AzureRmRoleAssignment -ResourceGroupName 'RBACTest' -RoleDefinitionName 'Owner' -SignInName 'rakytt@microsoft.com'

#PowerShell: Enumerate Existing Role JSON
Get-AzureRmRoleDefinition | where-object -Property Name -eq 'Contributor'
Get-AzureRmRoleDefinition | where-object -Property Name -eq 'Contributor' | Select-Object -ExpandProperty Actions
Get-AzureRmRoleDefinition | where-object -Property Name -eq 'Contributor' | Select-Object -ExpandProperty NotActions

#PowerShell: Add New Role Definition
New-AzureRmRoleDefinition -InputFile .\DevAzureContributor.json