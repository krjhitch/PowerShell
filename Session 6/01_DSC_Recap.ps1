#Basic DSC Recap

#---Build configuration function
configuration DemoDisableIPv6 {
    
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'

    node 'localhost' {
        Registry 'DisableIPv6' {
            Key       = 'HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters'
            ValueName = 'DisabledComponents'
            ValueData = 'ff00000'
            Hex       = $true
        }
    }
}
    
#---Call configuration to generate MOF file
Set-Location $env:temp
DemoDisableIPv6

#---Call Test-DSCConfiguration to test setting
Test-DscConfiguration -Path .\DemoDisableIPv6

#---Call Start-DSCConfiguration to test/fix setting
Start-DscConfiguration -Path .\DemoDisableIPv6

Get-Job
Get-Job | Receive-Job

#---Verify with Test-DSCConfiguration that it worked
Test-DscConfiguration -Path .\DemoDisableIPv6

#---Prove that Start-DSCConfiguration will now test/skip that code
Start-DscConfiguration -Path .\DemoDisableIPv6 -Wait -Verbose