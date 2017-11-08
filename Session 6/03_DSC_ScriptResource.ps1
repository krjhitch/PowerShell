#Script Resource
Get-DSCResource -Module PSDesiredStateConfiguration

Get-DscResource -Name Script
Get-DscResource -Name Script | Select-Object Properties
Get-DSCResource -Name Script | Select-Object -ExpandProperty Properties

#Define how PowerShell will build the MOF
configuration DEMOScriptResource {
    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    
    node 'member1' {

        Registry 'SomeRegistryKeyWhoCares' {
            Key       = 'HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters'
            ValueName = 'DisabledComponents'
            ValueData = 'ff00000'
            Hex       = $true
        }

        Script 'cVolumeFileSystemLabel' {
            GetScript  = {
                Get-Volume -DriveLetter C
            } 
            TestScript = {
                (Get-Volume -DriveLetter C).FileSystemLabel -eq 'DemoText'
            }
            SetScript  = {
                Set-Volume -DriveLetter C -NewFileSystemLabel 'DemoText'
            }
        }
    }
}

#String vs Scriptblock - Discussion
$test = 'this is a test'
$test.gettype()
$test = {'this is a test'}
$test.gettype()

#Create MOF
DEMOScriptResource

#Run MOF (and -wait and -verbose)
Start-DscConfiguration -Path .\DEMOScriptResource -Wait -Verbose


#PowerShell to View what we just did with DSC
Invoke-Command -ComputerName 'member1','member2','member3' -ScriptBlock {
    Get-Volume -DriveLetter C
}

configuration DEMOScriptResource2 {
    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    
    node 'member1' {
        Script 'cVolumeFileSystemLabel' {
            GetScript  = {
                Get-Volume -DriveLetter C
            } 
            TestScript = {
                (Get-Volume -DriveLetter C).FileSystemLabel -eq 'Member1C'
            }
            SetScript  = {
                Set-Volume -DriveLetter C -NewFileSystemLabel 'Member1C'
            }
        }
    }

    node 'member2' {
        Script 'cVolumeFileSystemLabel' {
            GetScript  = {
                Get-Volume -DriveLetter C
            } 
            TestScript = {
                (Get-Volume -DriveLetter C).FileSystemLabel -eq 'Member2C'
            }
            SetScript  = {
                Set-Volume -DriveLetter C -NewFileSystemLabel 'Member2C'
            }
        }
    }
}

#Build MOF and execute it
DEMOScriptResource2
Start-DscConfiguration -Path .\DEMOScriptResource2

#Verify
Invoke-Command -ComputerName 'member1','member2','member3' -ScriptBlock {
    Get-Volume -DriveLetter C
}

configuration DEMOScriptResource3 {
    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    
    node 'member1' {

        $TestName = 'ChevyChase'

        Script 'cVolumeFileSystemLabel' {
            GetScript  = {
                Get-Volume -DriveLetter C
            } 
            TestScript = {
                (Get-Volume -DriveLetter C).FileSystemLabel -eq $using:TextName
            }
            SetScript  = {
                Set-Volume -DriveLetter C -NewFileSystemLabel $using:TestName
            }
        }
    }
}
DEMOScriptResource3
Start-DscConfiguration -Path .\DEMOScriptResource3

#Verify
Invoke-Command -ComputerName 'member1','member2','member3' -ScriptBlock {
    Get-Volume -DriveLetter C
}

#Look at MOF...
psedit .\DEMOScriptResource3\member1.mof