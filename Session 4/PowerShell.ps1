#Modules
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





#JEA
#Do a bunch of JEA
#JEA Filesystem Layout