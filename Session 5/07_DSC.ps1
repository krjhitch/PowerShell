#Multiple Resource Example

Configuration CreateManagementServer {
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Node 'localhost' {

        WindowsFeature 'HyperVTools' {
            Ensure = 'Present'
            Name   = 'Hyper-V-Tools'
        }
        WindowsFeature 'RSATADTools' {
            Ensure = 'Present'
            Name   = 'RSAT-AD-Tools'
        }
        WindowsFeature 'RSAT-ADDS-Tools' {
            Ensure = 'Present'
            Name   = 'RSAT-ADDS-Tools'
        }
        WindowsFeature 'Web-Mgmt-Tools' {
            Ensure = 'Present'
            Name   = 'Web-Mgmt-Tools'
        }
        WindowsFeature 'RSAT-RDS-Tools' {
            Ensure = 'Present'
            Name   = 'RSAT-RDS-Tools'
        }
    }
}

#---------------------------------------------------------------------------
Set-Location -Path $env:TEMP

CreateManagementServer

Test-DSCConfiguration -Path CreateManagementServer

Start-DSCConfiguration -Path CreateManagementServer
