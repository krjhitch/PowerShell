#Exploring the Local Configuration Manager (DSC Engine)

#Find LCM Commands
Get-Command *LCM*
Get-Command *LocalConfigurationManager*

#View local LCM
Get-DSCLocalConfigurationManager

#Explore LCM options
Get-Help Get-DscLocalConfigurationManager
get-help Get-DscLocalConfigurationManager -detailed #Note CIMSession

Get-Help About_CIM
Get-DscLocalConfigurationManager -CimSession 'localhost'
Get-DscLocalConfigurationManager -CimSession 'member2'
Get-DscLocalConfigurationManager -CimSession 'localhost', 'member2'

#Throwing it all together
Get-DscLocalConfigurationManager -CimSession 'member1','member2','member3' | 
    Format-Table PSComputerName, ConfigurationMode, LCMState, RebootNodeIfNeeded, ActionAfterReboot |
    Sort-Object -Property PSComputerName -Descending

#Change Settings
Set-DscLocalConfigurationManager
#Path??
Get-Help Set-DscLocalConfigurationManager -Examples

#Where do I get info?
Start-Process 'https://docs.microsoft.com/en-us/powershell/dsc/metaconfig'

#Creating a 'META' MOF file to manage the LCM
[DSCLocalConfigurationManager()]
configuration DEMOLCMConfig
{
    Node localhost
    {
        Settings
        {
            RebootNodeIfNeeded = $false
            ConfigurationMode = 'ApplyAndAutoCorrect'
        }
    }
} 

#Make me a (META) MOF!
DEMOLCMConfig

#Make it so
Set-DscLocalConfigurationManager -Path .\DEMOLCMConfig

#(Same Commands as before)
Get-DscLocalConfigurationManager -CimSession 'member1','member2','member3' | 
    Format-Table PSComputerName, ConfigurationMode, LCMState, RebootNodeIfNeeded, ActionAfterReboot |
    Sort-Object -Property PSComputerName -Descending