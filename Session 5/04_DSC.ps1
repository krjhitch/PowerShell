#Use ConfigurationData to generate MOFs for multiple nodes
#https://docs.microsoft.com/en-us/powershell/dsc/configdata

$myData = @{
    AllNodes = @(
        @{NodeName='member1'},
        @{NodeName='member2'},
        @{NodeName='member3'}
    )
    NonNodeData = @{}
}

Configuration WebsiteTest {
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Node $AllNodes.NodeName {

        WindowsFeature WebServer {
            Ensure = "Present"
            Name   = "Web-Server"
        }

        File WebsiteContent {
            Ensure          = 'Present'
            SourcePath      = 'c:\windows\temp\index.htm'
            DestinationPath = 'c:\inetpub\wwwroot'
        }

    }
}

#---------------------------------------------------------------------------
Set-Location -Path $env:TEMP

WebsiteTest -ConfigurationData $myData

Test-DSCConfiguration -Path WebSiteTest

Start-DSCConfiguration -Path WebSiteTest
