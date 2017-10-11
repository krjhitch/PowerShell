#Use ConfigurationData to allow individual settings per node

$myData = @{
    AllNodes = @(
        @{
            NodeName='member1'
            IISshouldBe = 'Present'
        },
        @{
            NodeName='member2'
            IISshouldBe = 'Absent'
        },
        @{
            NodeName='member3'
            IISshouldBe = 'Present'
        }
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
            Ensure = $Node.IISShouldBe
            Name   = "Web-Server"
        }

        File WebsiteContent {
            Ensure          = $Node.IISShouldBe
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
