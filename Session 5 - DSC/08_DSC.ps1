#Multiple Resource Example (Consolidated.  We can use all of PowerShell!)

Configuration CreateManagementServer {
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Node 'localhost' {
        $myToolList = 'Hyper-V-Tools',     #Hyper-V Management
                      'RSAT-AD-Tools',     #AD Management (Snap-ins and command line tools)
                      'RSAT-ADDS-Tools',   #AD Management (AD and LDS tools)
                      'Web-Mgmt-Tools',    #IIS Management
                      'RSAT-RDS-Tools'     #Remote Desktop Services

        $myToolList | ForEach-Object {
            WindowsFeature "Resource-$_" {
                Ensure = 'Present'
                Name   = $_
            }
        }
    }
}

#---------------------------------------------------------------------------
Set-Location -Path $env:TEMP

CreateManagementServer

Test-DSCConfiguration -Path CreateManagementServer

Start-DSCConfiguration -Path CreateManagementServer
