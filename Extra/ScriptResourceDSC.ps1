configuration 'ScriptTest' {
    node 'localhost' {
        Script 'ScriptResourceOne' {
            GetScript = {
                return @{Results = $PSVersionTable.PSVersion.Major.ToString()}
            }
            TestScript = {
                $version = (Invoke-Expression $GetScript).Results
                write-verbose $version
                if($version -ge '5'){
                    write-verbose 'Version is 5+'
                    return $true
                }
                else {
                    write-verbose 'version is less than 5'
                    return $false
                }
            }
            SetScript = {
                write-verbose 'FIXING OMG'
            }
        }
    }
}

set-location $env:temp
ScriptTest
Start-DscConfiguration -Path .\ScriptTest -Wait -Verbose -force