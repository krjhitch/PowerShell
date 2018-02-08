
Get-WMIObject -Class Win32_ServerConnection                                                      #Retrieves a list of users connected to file shares on the local system
Get-WMIObject -Class Win32_ServerConnection | Select-Object UserName, ComputerName, ShareName    #As above, but with more formatting

query.exe user

Get-Service -Name APP*                                                                     #Return all services that name starts with APP
Get-Service -Name APP* | Where-Object -Property Status -EQ Running                         #Return all services that name starts with APP and are Running
Get-Service -Name APP* | Where-Object {($_.ServicesDependedOn).Name -contains 'CryptSvc'}  #Return all services that starts with APP and depends on the crypto service
Get-Service -Name APP* | Select -First 1                                                   #Return the first service that starts with APP
(Get-Service -Name APP* | Select -First 2) | Select *                                      #Show the properties of the first 2 services that start with APP
(Get-Service -Name APP* | Select -First 2) | Select Name, ServicesDependedOn               #Show the Name and ServiceDependedOn list for the first 2 services that start with APP
(Get-Service -Name AppIDSvc).ServicesDependedOn                                            #Retrieve the ServicesDependedOn objects
((Get-Service -Name AppIDSvc).ServicesDependedOn).GetType()                                #Notice that the object returned is an ARRAY of SERVICECONTROLLER objects

Get-ADComputer -Filter *

Get-WindowsFeature -Name *tools*                                                     #Get-WindowsFeature for something, but I forget what - *tools* oughta show me enough to cover it
Get-WindowsFeature -Name *adds*                                                      #Yup, looks like there's an ADDS section for Active Directory Domain Services - searching for *ADDS* should get me everything related to that
Add-WindowsFeature -Name RSAT-ADDS -IncludeManagementTools                           #Let's add the base RSAT-ADDS module, and -IncludeManagementTools will make sure we get the sub compontants we're looking for that are snapin/PowerShell related

Get-ADComputer -Filter *                                                             #List of all the computers in our domain - Great, but broad
Get-ADComputer -Filter * | Select Name                                               #Get the list of all computers in our domain (but just the name)
Get-ADComputer -Filter * | Select Name, DistinguishedName                            #Get the list of all computers in our domain (name, but also location)

(Get-ADComputer -Filter *).Gettype()                                                 #What type of objects are returned?
$results = Get-ADComputer -Filter *                                                  #Save the objects returned to a variable $results
$results.Name                                                                        #Now you can access $results (array) .properties without calling out to AD again and again

Get-Command -Name *AD*                                                               #What are my AD commands?
Get-Command -Name *ADOrg*                                                            #Looking for ADOU or ADOrganizational Units or ADOUs or some OU commands in AD
Get-ADOrganizationalUnit                                                             #Try to run it by itself but it asks for mandatory parameters
Get-ADOrganizationalUnit -Filter *                                                   #* means no filter
Get-ADOrganizationalUnit -Filter * | Select DistinguishedName                        #Get all the OUs but only give me the DN of each object
Get-ADOrganizationalUnit -Filter * | Where-Object -Property Name -match 'SIO'        #Get all OUs but just give me ones that have SIO on the name
Get-ADOrganizationalUnit -Filter * | Where-Object -Property Name -match 'SIO' | Select Name, DistinguishedName #Same as before, but format better

Get-ADUser -SearchBase '' -Filter * | Select * -First 1                              #Get all properties of first User object in specified OU
Get-ADUser -SearchBase '' -Filter * | Select SAMAccountName, UserPrincipalName       #Get all users in specified OU but just get SAMAccountName and UPN


Get-ADComputer -SearchBase 'CN=Computers,DC=domain,DC=local'                         #Get all computers in specified OU
Get-ADComputer -SearchBase 'CN=Computers,DC=domain,DC=local' -Filter *               #Again, needs mandatory parameter -filter
Get-ADComputer -SearchBase 'CN=Computers,DC=domain,DC=local' -Filter * | Select-Object Name, ObjectClass, DistinguishedName #Add formatting

Get-ADComputer -SearchBase 'CN=Computers,DC=domain,DC=local' -Filter *               #Same as before
$Computers = Get-ADComputer -SearchBase 'CN=Computers,DC=domain,DC=local' -Filter *  #Save results
$Computers                                                                           #Show objects (returns an array of strings)
$Computers.Name                                                                      #Show Name property of all objects in array

Test-NetConnection -ComputerName                                                     #[String from Intellisense for property means it'll only take one string
Test-NetConnection -ComputerName $Computers.Name
Test-NetConnection -ComputerName $Computers.Name[0]
Test-NetConnection -ComputerName $Computers.Name[1]
Test-NetConnection -ComputerName $Computers.Name[2]

$Computers.Name                                                                      #Display Array
$Computers.Name | ForEach-Object {                                                   #For Each element in the array, test-netconnection to computer
    Test-NetConnection -ComputerName $_
} 

ForEach ($computer in ($computers.name)){                                            #Alternate way to iterate through an array and run a command
    write-host "THIS IS A COMPUTERNAME: $Computer"
}

$Computers.Name | ForEach-Object {                                                   #Format results with | Select after objects are returned
    Test-NetConnection -ComputerName $_
} | Select ComputerName, PingSucceeded

$Computers.Name | ForEach-Object {                                                   #Format with Out-GridView (only available in the PowerShell ISE)
    Test-NetConnection -ComputerName $_
} | Out-GridView                                                                      

hostname
Get-ComputerInfo
Get-ComputerInfo | Select-Object OSName, OSBuildNumber, OSUptime

#If 2008R2 run Enable-PSRemoting

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
Get-NetFirewallRule | Select-Object DisplayName, Enabled, Direction
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
} | Select-Object PSComputerName, OSName, OSBuildNumber, OSUptime



$directoryname = 'c:\windows\temp'
Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    (Get-ChildItem -Path $directoryname)[0]
}



Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    (Get-ChildItem -Path $using:directoryname)[0]
}

Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    [PSCustomObject]@{
        Results = $PSVersionTable.PSVersion.Major
    }
}



Get-Command *new*user*
Get-Command New-LocalUser -ShowCommandInfo

New-LocalUser -Name localuser -Password 'ThisismyPassword'
$test = 'ThisismyPassword'
$test.GetType()
$test = ConvertTo-SecureString -String 'ThisismyPassword' -AsPlainText -Force
$test.GetType()
#Get-Credential


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

Invoke-Command -ComputerName $Computers.Name[2] -Credential $Credentials -Authentication basic -ScriptBlock {
    hostname
    whoami
}

invoke-command -ComputerName $computers.name[2] -ScriptBlock {
    Add-LocalGroupMember -Group Administrators -Member localuser
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

Get-Credential -Message 'This is the admin credential' -UserName 'domain\keihi'

Enter-PSSession -ComputerName $Computers.Name[2]             #Line1     Run Line 1 - 3 one at a time, notice how you'll get the remote system as your result
 hostname                                                    #Line2   
Exit-PSSession                                               #Line3     Run Line 1 - 3 at the same time, you'll notice it doesn't work - it never enters the session.  PSSession CANNOT be used in a script

Set-Location \\$($Computers.Name[2])\C$
Get-NetFirewallRule | Where-Object -Property DisplayName -like *file*
Get-NetFirewallRule | Where-Object -Property DisplayName -like *file* | Select DisplayName, Enabled, Direction
Enable-NetFirewallRule -DisplayName 'File and Printer Sharing (SMB-In)'

Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    #Enable-NetFirewallRule -DisplayName 'File and Printer Sharing (SMB-In)'
    Get-NetFirewallRule -DisplayName 'File and Printer Sharing (SMB-In)'
}

Set-Location -Path \\$($Computers.Name[2])\c$
Set-Location -Path C:\

Enter-PSSession -ComputerName $Computers.Name[2]
 Set-Location -Path \\$($Computers.Name[2])\C$
 Set-Location -Path \\random1234123\c$
 Set-Location -Path \\random123\c$
Exit-PSSession

Set-Location -Path \\random1234123\c$
Set-Location -Path \\random123\c$

Start-Process 'https://technet.microsoft.com/en-us/library/cc772815(v=ws.10).aspx'  #Kerberos Discussions

<#LABRESET
Invoke-Command -ComputerName $Computers.Name -ScriptBlock {
    Disable-NetFirewallRule -DisplayName 'File and Printer Sharing (SMB-In)'
}
#>

Invoke-Command -ComputerName $Computers.Name[2] -ScriptBlock {
    $results = 50
    $results
}

Invoke-Command -ComputerName $Computers.Name[2] -ScriptBlock {
    $results
}

New-PSSession -ComputerName $Computers.Name[2] -Credential $Credentials
$session = New-PSSession -ComputerName $Computers.Name[2] -Credential $Credentials

Invoke-Command -Session $session -ScriptBlock {
    $results = 100
    $results
}

Invoke-Command -Session $session -ScriptBlock {
    $results
}

Copy-Item -Path .\TS_F638.tmp -Destination C:\windows\temp -ToSession $session


Get-Job
Start-Job -ScriptBlock {Start-Sleep -Seconds 10}
Get-Job

Get-Job
Remove-Job -Id 118
Get-Job
Get-Job | Remove-Job


Start-Job -ScriptBlock {
    Start-Sleep -Seconds 10
    'I am done!'
}
Get-Job

Get-Job
Receive-Job -Name Job126
Get-Job | Remove-Job




 ## Moving Files