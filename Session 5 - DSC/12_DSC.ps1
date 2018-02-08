#Find and Download DSC Resources

Get-DscResource

Find-Module -Name xActiveDirectory
Find-Module -Name xSQLServer
Find-Module -Name xNetworking

Install-Module -Name xNetworking

Get-ChildItem -Path 'C:\Program Files\WindowsPowerShell\Modules'

Get-DSCResource -Module xNetworking

Get-DSCResource -Name xFirewall
(Get-DSCResource -Name xFirewall).Properties

Configuration 'FirewallTest' {
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName xNetworking

    node 'localhost' {
        xFirewall 'TestFirewallRule1' {
            Name        = 'Block Port 5000'
            Action      = 'Block'
            Description = 'This is a test rule that might block a real port'
            LocalPort   = '5000'
        }
    }
}

Set-Location -Path $env:TEMP

FirewallTest

Test-DSCConfiguration -Path .\FirewallTest

Start-DSCConfiguration -Path .\FirewallTest

#--------------------------------------------------------------------------------------
Configuration 'FirewallTest' {
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName xNetworking

    node @('member1','member2','member3') {
        xFirewall 'TestFirewallRule1' {
            Name        = 'Block Port 5000'
            Action      = 'Block'
            Description = 'This is a test rule that might block a real port'
            LocalPort   = '5000'
        }
    }
}

Set-Location -Path $env:TEMP

FirewallTest

Test-DSCConfiguration -Path .\FirewallTest

Start-DSCConfiguration -Path .\FirewallTest

Copy-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\xNetworking' -Destination '\\member2\c$\Program Files\WindowsPowerShell\Modules'
Copy-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\xNetworking' -Destination '\\member3\c$\Program Files\WindowsPowerShell\Modules'


Test-DSCConfiguration -Path .\FirewallTest

Start-DSCConfiguration -Path .\FirewallTest