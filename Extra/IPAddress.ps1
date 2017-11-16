get-netipaddress

get-netadapter -Name 'Ethernet'

'4','5','11','17','22','28','29','30','31','32','34','36','43','44' |
    ForEach-Object {
        Write-Host "Adding IP $_"
        New-NetIPaddress -IPAddress "192.168.18.$_" -InterfaceAlias 'Ethernet'
    }

'4','5','11','17','22','28','29','30','31','32','34','36','43','44' |
    ForEach-Object {
        Remove-NetIPaddress -IPAddress "192.168.18.$_" -InterfaceAlias 'Ethernet'
    }