#How to implement PowerShell DSC
New-Item -ItemType File -Path 'C:\windows\temp\index.htm' -Value "<head></head><body><p>Hello World!</p></body>"

#-----------------------------------------------------
Configuration WebsiteTest {
        Import-DscResource -ModuleName PsDesiredStateConfiguration
        Node 'localhost' {
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

#--------------------------------------------------------
Set-Location -Path $env:TEMP

WebsiteTest

Test-DSCConfiguration -Path WebSiteTest

Start-DSCConfiguration -Path WebSiteTest

#---------------------------------------------------------
