#Use ConfigurationData to replace data inside of the Configuration block

$myData = @{
    AllNodes = @(
        @{NodeName='member1'},
        @{NodeName='member2'},
        @{NodeName='member3'}
    )
    NonNodeData = @{
        myFileLocation    = 'c:\windows\temp\index.htm'
        myWebSiteLocation = 'c:\inetpub\wwwroot'
    }
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
            SourcePath      = $ConfigurationData.NonNodeData.myFileLocation
            DestinationPath = $ConfigurationData.NonNodeData.myFileLocation
        }

    }
}

#---------------------------------------------------------------------------
Set-Location -Path $env:TEMP

WebsiteTest -ConfigurationData $myData

Test-DSCConfiguration -Path WebSiteTest

Start-DSCConfiguration -Path WebSiteTest
