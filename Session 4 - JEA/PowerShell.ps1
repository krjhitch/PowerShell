#Modules-----------------------------------------------------------------------------------------------------
Get-ADComputer -Filter * | Select Name, DistinguishedName

#Remove-WindowsFeature -Name RSAT-AD-Tools (then re-launch console)
Add-WindowsFeature -Name RSAT-AD-Tools

Get-ADComputer -Filter * | Select Name, DistinguishedName

Get-Command Get-ADComputer
Get-Command Get-ADComputer -Module ActiveDirectory
Get-Command -Module ActiveDirectory

Import-Module -Name ActiveDirectory

$env:PSModulePath
$env:PSModulePath -split ';'
$env:PSModulePath -split ';' | ForEach-Object {Get-ChildItem -Path $_}
#PSModulePath that matters = C:\Program Files\WindowsPowerShell\Modules

#Step 1 - Put a module in a valid $env:PSModulePath directory
#Step 2 - Either Import-Module or relaunch PowerShell (ISE or Window)

#Show Modules Loaded
Get-Module

#Show Modules Available on System
Get-Module -ListAvailable

Find-Module -Name *DSC*
Find-Module -Name *JEA*

Find-Module -Name Carbon
Install-Module -Name Carbon
Install-Module -Name Carbon -AllowClobber

Get-Module -Name Carbon
Import-Module -Name Carbon
Get-Module -Name Carbon

Get-Command -Module Carbon
Get-Command -Name Get-IPAddress

Get-Help Test-IPAddress
Test-IPAddress -IPAddress 10.0.0.1

$env:PSModulePath -split ';' | ForEach-Object {Get-ChildItem -Path $_}

Save-Module -Name Carbon -Path $env:temp
Get-ChildItem -Path $env:temp

# Filesystem Layout
#
#      C:\Program Files\WindowsPowerShell\Modules
#                                             \<NAME>
#                                                 \[<Version>]
#                                                        \<Module>.psd1   (PS Data File - Has Module Metadata)
#                                                        \<Module>.psm1   (PS Module File - Has Code) 
#           

#Make sure you are in C:\Program Files\WindowsPowerShell\Modules
Set-Location -Path 'C:\Program Files\WindowsPowerShell\Modules'
Get-Location

                           
New-item -ItemType Directory -Path .\ChevyChase
Set-Location -Path .\ChevyChase
Get-ChildItem

New-Item -ItemType File -Path .\ChevyChase.psm1
PSEdit .\ChevyChase.psm1

#function DEMOFUNCTION {
#    Write-Host 'I AM A DEMO FUNCTION'
#}
#
#Export-ModuleMember -Function DEMOFUNCTION

New-ModuleManifest -RootModule .\ChevyChase.psm1 -Path .\ChevyChase.psd1 
PSEdit .\ChevyChase.psd1
#      C:\Program Files\WindowsPowerShell\Modules
#                                             \CHEVYCHASE
#                                                    \CHEVYCHASE.psd1   (HAS ROOTMODULE = CHEVYCHASE.PSM1)
#                                                    \CHEVYCHASE.psm1   (HAS FUNCTIONS) 

DEMOFUNCTION

Import-Module -Name ChevyChase
Get-Command -Module ChevyChase

DEMOFUNCTION





#JEA---------------------------------------------------------------------------------------------------------------------
#JEA Consits of
#1) Create empty module
#2) Create PSRC (PowerShell Role Capabilities) file - defines what a user can DO in PowerShell
#3) Create PSSC (PowerShell Session Configuration) file - defines which users get which PSRC permissions, and also
#       defines metadata like logon scripts, runas account, name of endpoint

#      C:\Program Files\WindowsPowerShell\Modules
#                                             \JEADEMO
#                                                    \JEADEMO.psd1   (HAS ROOTMODULE = JEADEMO.PSM1)
#                                                    \JEADEMO.psm1   (Empty File) 
#                                                    \RoleCapabilities
#                                                            \HelpdeskRole.psrc
#                                                            \SuperAdminRole.psrc

#Create JEADEMO Module Folder
Set-Location -Path 'C:\Program Files\WindowsPowerShell\Modules'
Get-ChildItem
New-item -ItemType Directory -Path .\JEADEMO

Set-Location -Path .\JEADEMO
Get-ChildItem

#Create RoleCapabilities Folder
New-item -ItemType Directory -Path .\RoleCapabilities
Get-ChildItem

#Create JEADEMO Module
New-Item -ItemType File -Path .\JEADEMO.psm1
New-ModuleManifest -RootModule .\JEADEMO.psm1 -Path .\JEADEMO.psd1 

#Create Capabilities Files
New-PSRoleCapabilityFile -Path .\RoleCapabilities\HelpdeskRole.psrc -VisibleCmdlets 'Get-WinEvent'
New-PSRoleCapabilityFile -Path .\RoleCapabilities\SuperAdminRole.psrc -VisibleCmdlets 'Get-*'

New-PSSessionConfigurationFile -Path .\JEADEMOEndPointConfigurationInformation.pssc -SessionType RestrictedRemoteServer -RoleDefinitions @{
    'DOMAIN\JEAAdmins'    = @{RoleCapabilities = 'SuperAdminRole'}
    'DOMAIN\HelpdeskAdmins' = @{RoleCapabilities = 'HelpdeskRole'  }
}

#Take a look at the endpoint configuration info
PSEdit .\JEADEMOEndPointConfigurationInformation.pssc

#Test the Configuration
Test-PSSessionConfigurationFile -Path .\JEADEMOEndPointConfigurationInformation.pssc

#Create Groups
New-ADGroup -Name 'HelpdeskAdmins'-GroupScope Universal
New-ADGroup -Name 'JEAAdmins' -GroupScope Universal

#Create Users
$CredentialObject = Get-Credential -UserName 'UsernameIrrelevent' -Message 'Password for next step'
New-ADUser -Name 'TEST_HelpdeskAdmin' -AccountPassword $CredentialObject.Password -Enabled $true
New-ADUser -Name 'TEST_JEAAdmin'      -AccountPassword $CredentialObject.Password -Enabled $true

#Add Users to Groups
Add-ADGroupMember -Identity 'HelpdeskAdmins' -Members 'TEST_HelpdeskAdmin'
Add-ADGroupMember -Identity 'JEAAdmins'      -Members 'TEST_JEAAdmin'

#Register the JEA Endpoint
Register-PSSessionConfiguration -Name 'JEAEndpoint' -Path .\JEADEMOEndPointConfigurationInformation.pssc
#Unregister-PSSessionConfiguration -Name 'JEAEndpoint'

#Verify the Endpoint Exists
Get-PSSessionConfiguration | Select Name

#Verify details of the Endpoint
Get-PSSessionConfiguration -Name JEAEndpoint | Select *

#----------------------------------------------------------------------------------------------------------------------------------------------------
#Switch to Server 2
#Find my target computer
Get-ADComputer -Filter * | Select Name
$computer = 'random123' 


#Log in as current user (who is an admin on the remote system; default powershell endpoint)
Enter-Pssession -ComputerName $computer
    whoami.exe
    Get-Command
    (Get-Command).Count

Exit-PSSession

#Build my user credentials
$TestHelpdeskUser = Get-Credential -UserName 'DOMAIN\TEST_HelpdeskAdmin' -Message 'Please enter password'
$TestAdminUser    = Get-Credential -UserName 'DOMAIN\TEST_JEAAdmin'      -Message 'Please enter password'

#Try to log in as these users; Access denied.  Why? Because they aren't local admins
Enter-PSSession -ComputerName $computer -Credential $TestHelpdeskUser
Enter-PSSession -ComputerName $computer -Credential $TestAdminUser

#Try to log in as this user but user the JEAEndpoint
Enter-PSSession -ComputerName $computer -Credential $TestHelpdeskUser -ConfigurationName JEAEndpoint
    whoami.exe
    Get-Command
    (Get-Command).Count

Exit-PSSession

#Try to log in as this user but user the JEAEndpoint
Enter-PSSession -ComputerName $computer -Credential $TestAdminUser -ConfigurationName JEAEndpoint
    whoami.exe
    Get-Command
    (Get-Command).Count

Exit-PSSession

#Invoke-Script Stuff