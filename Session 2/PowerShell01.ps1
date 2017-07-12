## What is a PowerShell Function?                                               
help about_Function                                                             #As Always, Help (or Get-Help) is a great resource for the about_*  You can't get any more authorative than PowerShell itself
                                                                                
#When would I use a function                                                    
Get-Process                                                                     #A normal cmdlet, no parameters - shows too much data
Get-Process -Name PowerShell_ISE                                                #The same cmdlet as above, but this time it's been restricted to just show us any running processes that match the name
                                                                                
function Get-PowerShellProcess {                                                #A basic function
    Get-Process -Name PowerShell_ISE                                            #You write whatever you want in the script block { }
}                                                                               
Get-PowerShellProcess                                                           #Actually Executes the function (after it's been defined)
                                                                                
Get-Variable                                                                    #Shows all the default variables that are loaded into the current session
$Profile                                                                        #$Profile is a location where when you launch PowerShell it will look for that file and execute it

New-Item -ItemType File -Path $Profile -Value "Write-Host 'PowerShell Loaded'"  #Creates a file at $Profile (Path) which runs every time PowerShell is loaded
Invoke-Expression $Profile                                                      #Invoke-Expression is a cmdlet that executes a string

Get-PSDrive    #(Notice that there is a Function: drive)
Dir Function:* #Get-ChildItem Function:*
Dir Function:\Clear-Host
Dir Function:\Clear-Host | Format-List
(Dir Function:\Clear-Host ).Definition


#-------------------------------------------
function OneHourAgo {
    (Get-Date).AddHours(-1)
}
OneHourAgo

#-------------------------------------------
function HoursAgo {
    (Get-Date).AddHours($args[0])
}
HoursAgo -1
HoursAgo -2
HoursAgo 0

#-------------------------------------------
function HoursAgo {
    param($HoursInThePast)

    (Get-Date).AddHours($HoursInThePast)
}
HoursAgo 0
HoursAgo -HoursInThePast -1
HoursAgo -HoursInThePast -10

#-------------------------------------------
function HoursAgo ($HoursInThePast) {
    (Get-Date).AddHours($HoursInThePast)
}
HoursAgo 0
HoursAgo -HoursInThePast -1
HoursAgo -HoursInThePast -10

#-------------------------------------------
function AddTwoValues ($value1, $value2) {
    $answer = $value1 + $value2
    Write-Host "When I add $value1 and $value2 I get: $answer"
}
AddTwoValues -value1 1 -value2 9
AddTwoValues -value1 1 -value2 '9'
AddTwoValues -value1 '1' -value2 9
AddTwoValues -value1 1
AddTwoValues

#-------------------------------------------
function AddTwoValues ([Int]$value1, [Int]$value2) {
    $answer = $value1 + $value2
    Write-Host "When I add $value1 and $value2 I get: $answer"
}
AddTwoValues -value1 1 -value2 '9'
AddTwoValues -value1 '1' -value2 9
AddTwoValues

#-------------------------------------------
function AddTwoValues {
    param(
        [Int]$value1,
        [Int]$value2
    )
    $answer = $value1 + $value2
    Write-Host "When I add $value1 and $value2 I get: $answer"
}
AddTwoValues -value1 1 -value2 '9'
AddTwoValues -value1 '1' -value2 9
AddTwoValues

#-------------------------------------------
function AddTwoValues {
    param(
        [Parameter(Mandatory=$true)][Int]$value1,
        [Parameter(Mandatory=$true)][Int]$value2
    )
    $answer = $value1 + $value2
    Write-Host "When I add $value1 and $value2 I get: $answer"
}
AddTwoValues -value1 1 -value2 '9'
AddTwoValues -value1 '1' -value2 9
AddTwoValues

#-------------------------------------------
function HoursAgo {
    param(
        [ValidateScript({$_ -ge 0})]
        [Parameter(Mandatory=$true)]
        [Int]$HoursInThePast
    )
    (Get-Date).AddHours(0 - $HoursInThePast)
}
HoursAgo 0
HoursAgo -HoursInThePast 10
HoursAgo -HoursInThePast -10

#-------------------------------------------
$numbers = 1..100
function DisplayArray {
    param([Array]$Array)
    $Array | ForEach-Object {
        Write-Host '$_ is equal to', $_
    }
}
DisplayArray -Array $numbers

#-------------------------------------------
Get-Content .\README.md
Copy-Item -Path .\README.md -Destination .\README2.md
Copy-Item -Path .\README.md -Destination .\README2.md -Verbose

#-------------------------------------------
function SquareNumber {
    param([Int]$number)
    
    return ($number*$number)
}
SquareNumber -number 1
SquareNumber -number 2
SquareNumber -number 3

$newNumber = SquareNumber -Number 10
$newNumber

#-------------------------------------------
function SquareNumber {
    param([Int]$number)
    
    Write-Host "Function is multiplying $number by $number"
    return ($number*$number)
}
SquareNumber -number 1
SquareNumber -number 2
SquareNumber -number 3

#-------------------------------------------
Write-Verbose "This is a verbose message"

function SquareNumber {
    [CmdletBinding()]
    param([Int]$number)
    
    Write-Verbose "Function is multiplying $number by $number"
    return ($number*$number)
}
SquareNumber -number 1
SquareNumber -number 2
SquareNumber -number 3
SquareNumber -number 10 -Verbose

#-------------------------------------------
Copy-Item -Path 'C:\users\Keith\github\PowerShell\README.md' -Destination 'C:\Users\Keith\github\PowerShell\README2.md' -Force -Verbose -ErrorAction 'SilentlyContinue'

$parameterHashTable = @{
    Path        = 'C:\users\Keith\github\PowerShell\README.md'
    Destination = 'C:\Users\Keith\github\PowerShell\README2.md'
    Force       = $true
    Verbose     = $true
    ErrorAction = 'SilentlyContinue'
}
Copy-Item @parameterHashTable

#-------------------------------------------

#Show that return is the last item no matter what

#Show file Remove-Item | Remove-Item
#Then go into Process Block
#Then go into Filter



#Differences between .NET method and PowerShell Function
Dir .\README.md                                    #Dir (Or Get-ChildItem) returns an object (A filesystem object)
(Dir .\README.md).GetType()                        #.GetType() proves that this is an object                 
Dir .\README.md | Get-Member                       # Get-Member shows all the properties and methods for a particular object


## PowerShell Script and Function Building

## Anatomy of a Function
#Parameters
 #Common Named Parameters (params block)
 #Uncommon Named Parameters (signature block)
#Arguments
#Returns
#Begin
#Process
#End


## Passing Parameters and Arguments
#Passing Parameters
#Splatting
#Verbose
#CmdletBinding
#InputValidation
#PSBoundParameters


## Processing the Pipeline and Filters
#Demonstration of processing on the pipeline
#Demonstration of building a filter
