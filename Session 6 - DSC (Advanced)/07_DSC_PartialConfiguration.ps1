cd $env:temp

#Define the MOF to tell DSC what to do
configuration ConfigureCachedLogons {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node 'Member3' {
        Registry 'Numberofpreviouslogonstocache' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
            ValueName = 'CachedLogonsCount'
            ValueType = 'Dword'
            ValueData = '2'
        }
    }
}

#Define the MOF to tell DSC what to do
configuration DisableUAC {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    Node 'Member3' {
        Registry 'ConsentPromptBehaviorAdmin' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueName = 'ConsentPromptBehaviorAdmin'
            ValueType = 'Dword'
            ValueData = '5'
        }  

        Registry 'PromptOnSecureDesktop' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueName = 'PromptOnSecureDesktop'
            ValueType = 'Dword'
            ValueData = '1'
        }
    }
}

#Define a META MOF to tell the LCM that it will have to evaluate 2 configurations
[DSCLocalConfigurationManager()]
configuration PartialConfigDemo
{
    Node 'Member3'
    {
        PartialConfiguration ConfigureCachedLogons {
            Description = 'This is the first set of configurations - perhapse baseline OS settings'
            RefreshMode = 'Push'
        }

        PartialConfiguration DisableUAC {
            Description = 'This is a second set of configurations - perhaps specific to an application'
            RefreshMode = 'Push'
        }
    }
}

#Create the Meta MOFs and MetaMOF
ConfigureCachedLogons
DisableUAC
PartialConfigDemo 

#Publish the MOFs to the remote node
Set-DscLocalConfigurationManager PartialConfigDemo 
Publish-DscConfiguration ConfigureCachedLogons
Publish-DscConfiguration DisableUAC

#Apply the partial configurations
Start-DSCConfiguration -ComputerName member3 –UseExisting -Wait -Verbose




