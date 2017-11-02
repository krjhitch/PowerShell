Copy-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\xsqlserver' -Recurse -Destination $env:temp
Set-Location $env:temp\xsqlserver
Copy-Item -Path .\8.2.0.0\* -Recurse -Destination .
Remove-Item .\8.2.0.0 -recurse -Force
Set-Location $env:temp
Compress-Archive -Path .\xsqlserver -DestinationPath xsqlserver.zip
Rename-Item -Path .\xsqlserver.zip xsqlserver_8.2.0.0.zip
New-DscChecksum -Path .\xsqlserver_8.2.0.0.zip
