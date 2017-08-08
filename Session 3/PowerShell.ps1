
Get-ADComputer -Filter *

Get-WindowsFeature -Name *tools*                                                     #Get-WindowsFeature for something, but I forget what - *tools* oughta show me enough to cover it
Get-WindowsFeature -Name *adds*                                                      #Yup, looks like there's an ADDS section for Active Directory Domain Services - searching for *ADDS* should get me everything related to that
Add-WindowsFeature -Name RSAT-ADDS -IncludeManagementTools                           #Let's add the base RSAT-ADDS module, and -IncludeManagementTools will make sure we get the sub compontants we're looking for that are snapin/PowerShell related

Get-ADComputer -Filter *                                                             #List of all the computers in our domain - Great, but broad
(Get-ADComputer -Filter *).Gettype()

Get-ADComputer -SearchBase 'CN=Computers,DC=domain,DC=local' -Filter *
Get-ADComputer -SearchBase 'CN=Computers,DC=domain,DC=local' -Filter * | Select Name, ObjectClass, DistinguishedName

Get-ADComputer -SearchBase 'CN=Computers,DC=domain,DC=local' -Filter *
$Computers = Get-ADComputer -SearchBase 'CN=Computers,DC=domain,DC=local' -Filter *
$Computers

$Computers.Name

Test-NetConnection -ComputerName
Test-NetConnection -ComputerName $Computers.Name
Test-NetConnection -ComputerName $Computers.Name[0]
Test-NetConnection -ComputerName $Computers.Name[1]
Test-NetConnection -ComputerName $Computers.Name[2]

$Computers.Name
$Computers.Name | ForEach-Object {
    Test-NetConnection -ComputerName $_
}

$Computers.Name | ForEach-Object {
    Test-NetConnection -ComputerName $_
} | Select ComputerName, PingSucceeded

$Computers.Name | ForEach-Object {
    Test-NetConnection -ComputerName $_
} | Out-GridView

hostname
Get-ComputerInfo
Get-ComputerInfo | Select OSName, OSBuildNumber, OSUptime

Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    hostname
}

Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    Get-ComputerInfo | Select OSName, OSBuildNumber, OSUptime
}

Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    Get-ComputerInfo | Select OSName, OSBuildNumber, OSUptime
} | Format-Table

Get-Command -Name *Firewall*
Get-Command -Name Get-*Firewall*
Get-NetFirewallRule
(Get-NetFirewallRule).DisplayName
Get-NetFirewallRule
Get-NetFirewallRule | Select DisplayName, Enabled, Direction
Get-NetFirewallRule | Where-Object -Property DisplayName -match 'ICMP' | Select DisplayName, Enabled, Direction

Enable-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv4-In)'

Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    Enable-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv4-In)'
}

$Computers.Name | ForEach-Object {
    Test-NetConnection -ComputerName $_
} | Select ComputerName, PingSucceeded

<#LABRESET
Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    Disable-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv4-In)'
}
#>

$Computers
$Computers.Name
$Computers.Name[0,2]

Restart-Computer -ComputerName $Computers.Name[0,2] -Wait -For PowerShell
Restart-Computer -ComputerName $Computers.Name[0,2] -Wait -For PowerShell -Protocol WSMan

Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    Get-ComputerInfo
} | Select PSComputerName, OSName, OSBuildNumber, OSUptime

Get-Command *new*user*
Get-Command New-LocalUser -ShowCommandInfo

New-LocalUser -Name localuser -Password 'ThisismyPassword'
$test = 'ThisismyPassword'
$test.GetType()
$test = ConvertTo-SecureString -String 'ThisismyPassword' -AsPlainText -Force
$test.GetType()

New-LocalUser -Name localuser -Password $test

$Password = ConvertTo-SecureString -String 'ComplexPassword123!' -AsPlainText -Force
New-LocalUser -Name localuser -Password $Password -Description 'Local user for Testing'
Get-LocalUser

Enter-PSSession -ComputerName $Computers.Name[2]
 Get-LocalUser
 $Password = ConvertTo-SecureString -String 'ComplexPassword123!' -AsPlainText -Force
 New-LocalUser -Name localuser -Password $Password -Description "Local user on $($Computers.Name[2]) Testing"
 Get-LocalUser
Exit-PSSession

$Credentials = Get-Credential
$Credentials.GetType()

Hostname
Invoke-Command -ComputerName $Computers.Name[2] -ScriptBlock {
    hostname
    whoami
}

Invoke-Command -ComputerName $Computers.Name[2] -Credential $Credentials -ScriptBlock {
    hostname
    whoami
}

New-ADUser -Name serviceaccount -AccountPassword $Password -Enabled $true
$Credentials = Get-Credential

Invoke-Command -ComputerName $Computers.Name[2] -Credential $Credentials -ScriptBlock {
    hostname
    whoami
}

Invoke-Command -ComputerName $Computers.Name[2] -ScriptBlock {
    Add-LocalGroupMember -Group 'Administrators' -Member 'Domain\serviceaccount'
}

Invoke-Command -ComputerName $Computers.Name[2] -Credential $Credentials -ScriptBlock {
    hostname
    whoami
}

$Credentials
$Credentials.UserName
$Credentials.Password

$Credentials.GetNetworkCredential() | Format-List

 # Enable PS-Remoting
 # Get Password Back for Script
 # WSMAN File for Remote Machines
 # Remotely Join the Domain
 ## Kerberos Double-Hop
 ## Moving Files
 ## Interactive
 ## Non-Interactive
 ## Sequential vs Threaded
 ## PS-Session / Get-History

#Jobs
 #Adding/removing jobs
 #Start-Sleep






#  Remote Administration
#  Credential Building
#  Kerberos Double-Hop
#  Interactive and Non-Interactive Sessions
#  Multi-threading Commands
#  PowerShell Jobs