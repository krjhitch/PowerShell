#Find a PowerShell Module
Find-Module *Audit*

#Find one that has DSC in the name - Install it
Install-Module AuditPolicyDSC -Force

#Verify that it's installed
Get-DscResource -Module AuditPolicyDSC

#Explore the Module
Get-DSCResource -Name AuditPolicySubCategory
Get-DSCResource -Name AuditPolicySubCategory | Select-Object -ExpandProperty Properties


#Start writing a configuration
configuration DemoCustomResource {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DSCresource -ModuleName 'AuditPolicyDSC'

    node 'localhost' {
        AuditPolicySubcategory 'DemoAuditResource' {
            AuditFlag = 'Failure'
            Name      = 'Logon'
            Ensure    = 'Present'
        }
    }
}

#Build MOF
DemoCustomResource

#Execute MOF
Start-DscConfiguration -Path .\DemoCustomResource -wait -Verbose -force

#Deep dive into module
Get-DSCResource -Name AuditPolicySubCategory
Get-DSCResource -Name AuditPolicySubCategory | Format-List
psedit (Get-DSCResource -Name AuditPolicySubCategory | Select-Object -ExpandProperty Path)





#Exploring Custom DSC Resources
#Creating Custom DSC Resources

