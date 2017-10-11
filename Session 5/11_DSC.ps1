#Set Some Security Options

Configuration SetSecurityBaselines {
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Node 'localhost' {
        #User Account Control - (1 of 2)
        Registry 'ConsentPromptBehaviorAdmin' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueName = 'ConsentPromptBehaviorAdmin'
            ValueType = 'Dword'
            ValueData = '5'
            DependsOn = "[Registry]PromptOnSecureDesktop"
        }  
        
        #User Account Control - (2 of 2)
        Registry 'PromptOnSecureDesktop' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System'
            ValueName = 'PromptOnSecureDesktop'
            ValueType = 'Dword'
            ValueData = '1'
        }

        #Interactive logon: Number of previous logons to cache (in case domain controller is not available)
        Registry 'Numberofpreviouslogonstocache' {
            Ensure    = 'Present'
            Key       = 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'
            ValueName = 'CachedLogonsCount'
            ValueType = 'Dword'
            ValueData = '2'
        }
    }
}

#---------------------------------------------------------------------------
Set-Location -Path $env:TEMP

SetSecurityBaselines 

Test-DSCConfiguration -Path SetSecurityBaselines

Start-DSCConfiguration -Path SetSecurityBaselines

#https://docs.microsoft.com/en-us/powershell/dsc/securemof
