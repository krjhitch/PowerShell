get-netadapter -Name 'Ethernet 3'

Get-NetIPaddress -InterfaceIndex 11
set-netipaddress -InterfaceIndex 11 -IPAddress '192.168.18.9' 


Get-NetIPInterface -InterfaceIndex 11
set-netipinterface -InterfaceIndex 11 -AddressFamily IPv4 -


new-NetIPAddress –InterfaceAlias “Ethernet 3” -IPAddress “192.168.18.18” –PrefixLength 24 
remove-netipaddress -interfacealias "Ethernet 3" -ipaddress "192.168.18.18" -PrefixLength 24 -confirm:$false

77..254 | ForEach-Object {
    Write-Host "Trying IP 192.168.18.$_"
    New-NetIPAddress –InterfaceAlias “Ethernet 3” -IPAddress “192.168.18.$_” –PrefixLength 24 | Out-Null
    Start-Sleep -Seconds 10
    Test-netConnection -ComputerName 'microsoft.com' -Port 80 | Select-Object TCPTestSucceeded
    Remove-NetIPAddress –InterfaceAlias “Ethernet 3” -IPAddress “192.168.18.$_” –PrefixLength 24 -confirm:$false  | Out-Null
}