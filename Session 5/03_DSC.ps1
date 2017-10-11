#Configure Multiple Nodes at Once

Configuration WebsiteTest {
        Import-DscResource -ModuleName PsDesiredStateConfiguration
        Node 'member1' {
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
        Node 'member2' {
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
        Node 'member3' {
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


Set-Location -Path $env:TEMP

WebsiteTest

Test-DSCConfiguration -Path WebSiteTest

Start-DSCConfiguration -Path WebSiteTest


#------------------------------------------------
New-Item -ItemType File -Path 'C:\windows\temp\index.htm' -Value "<head></head><body><p>Hello World!</p></body>"
Copy-Item -Path 'C:\windows\temp\index.htm' -Destination '\\member1\c$\windows\temp'
Copy-Item -Path 'C:\windows\temp\index.htm' -Destination '\\member2\c$\windows\temp'
Copy-Item -Path 'C:\windows\temp\index.htm' -Destination '\\member3\c$\windows\temp'
