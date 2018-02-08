#Management Server Example Continued - Groups
#https://docs.microsoft.com/en-us/powershell/dsc/builtinresource

New-ADGroup -Name 'ManagementServerAdmins'-GroupScope Universal

$CredentialObject = Get-Credential -UserName 'UsernameIrrelevent' -Message 'Password for next step'
New-ADUser -Name 'svc_ServiceAccount' -AccountPassword $CredentialObject.Password -Enabled $true

#--------------------------------------------------------------


Configuration CreateManagementServer {
    param(
        [PSCredential]$User
    )
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
        Group MgmtAdminsInLocalAdminGroup {
                GroupName        = 'Administrators'
                MembersToInclude = "$env:USERDOMAIN\ManagementServerAdmins"
                MembersToExclude = "$env:USERDOMAIN\svc_ServiceAccount"
                Credential       =  $User
        }
    }
}

#---------------------------------------------------------------------------
Set-Location -Path $env:TEMP

CreateManagementServer -User $UserCredObject

Test-DSCConfiguration -Path CreateManagementServer

Start-DSCConfiguration -Path CreateManagementServer
