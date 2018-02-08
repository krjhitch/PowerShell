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
Invoke-Expression (Get-Content $Profile | Out-String)                                                      #Invoke-Expression is a cmdlet that executes a string

Get-PSDrive                                                                     #(Notice that there is a Function: drive)
Dir Function:*                                                                  #Get-ChildItem Function:*
Dir Function:\Clear-Host                                                        #You can specify a function by name to see it
Dir Function:\Clear-Host | Format-List                                          #Format-List shows us all of the properties of the 'Function Object'
(Dir Function:\Clear-Host ).Definition                                          #The definition property shows us the code that the function will execute when called

#-------------------------------------------                                    #A basic function (more like a subroutine)
function OneHourAgo {                                                           #Defines function - into memory
    (Get-Date).AddHours(-1)
}
OneHourAgo                                                                      #Execute function

#-------------------------------------------                                    #A function that is written to accept an argument when called (by position)
function HoursAgo {                                                             #Defines function - into memory
    (Get-Date).AddHours(0 - $args[0])                                               #$args always exists for a function, it is the 'arguments array'.  The 0th index (first position) holds the first passed in argument
}
HoursAgo 1                                                                      #1 hour ago
HoursAgo 2                                                                      #2 hours ago
HoursAgo 0                                                                      #0 hours ago (now)
HoursAgo 'Keith'

#-------------------------------------------                                    #Same function as above, but with a named Parameter                    
function HoursAgo {                                                             #Define function - load into memory
    param($HoursInThePast)                                                      #param( ) block is for defining the parameters (names, types, constraints, positions)
    
    (Get-Date).AddHours(0 - $HoursInThePast)                                    #Same logic as above function
}
HoursAgo 0                                                                      #PowerShell knows where to put this because the first defined parameter is automatically position 0
HoursAgo -HoursInThePast 1                                                      #PowerShell function can now do IntelliSense and auto-complete 
HoursAgo -HoursInThePast 10
HoursAgo -HoursInThePast 72
HoursAgo -HoursInThePast 'Keith'

#-------------------------------------------
function HoursAgo ($HoursInThePast) {                                           #Same as above function but param block is missing.
    (Get-Date).AddHours($HoursInThePast)                                        #In this example, the parameters are defined on the function line
}                                                                               #This is rarer, but still valid - looks more like C/JAVA
HoursAgo 0
HoursAgo -HoursInThePast 1
HoursAgo -HoursInThePast 10

#-------------------------------------------
function AddTwoValues ($value1, $value2) {                                      #This function takes 2 values (by Name) and adds them together
    $answer = $value1 + $value2                                                 #calculate $answer
    Write-Host "When I add $value1 and $value2 I get: $answer"                  #Display a formatted string
}
AddTwoValues -value1 1 -value2 9                                                #Adds the values for 1 and 9 together = 10      
AddTwoValues -value1 1 -value2 '9'                                              #Adds the value for 1 with the value (converted) of 9 = 10
AddTwoValues -value1 '1' -value2 9                                              #Adds the character 1 to the character (converted) 9 = 19
AddTwoValues -value1 1                                                          #Demonstration that you can misuse this function by not providing all values
AddTwoValues                                                                    #Same as above.  No values   
AddTwoValues -value1 'Keith' -value2 'Hitchcock'                                #This works... maybe it was intended and maybe it wasn't 

#-------------------------------------------
function AddTwoValues ([Int]$value1, [Int]$value2) {                            #This function takes 2 values (by Name) and tries to convert them to Integers
    $answer = $value1 + $value2
    Write-Host "When I add $value1 and $value2 I get: $answer"
}
AddTwoValues -value1 1 -value2 '9'                                              #This works (as before)
AddTwoValues -value1 '1' -value2 9                                              #This now works because even though -value1 '1' is a String as written, the parameter knows it wants an Integer and will convert at the time it runs
AddTwoValues -value1 'Keith' -value2 'Hitchcock'                                #This is completely invalid now, since these String values cannot be converted, so you'll get an error
AddTwoValues

#-------------------------------------------
function AddTwoValues {                                                         #Same function as above, but this is the more common parameter style seen in PowerShell
    param(
        [Int]$value1,
        [Int]$value2
    )
    $answer = $value1 + $value2
    Write-Host "When I add $value1 and $value2 I get: $answer"
}
AddTwoValues -value1 1 -value2 '9'
AddTwoValues -value1 '1' -value2 9
AddTwoValues -value1 'Keith' -value2 'Hitchcock' 
AddTwoValues

#-------------------------------------------
function AddTwoValues {                                                         #Same as above, but we've added [Parameter(Mandatory=$true)] which means the function will not proceed without a value entered by the user
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
        [ValidateScript({$_ -ge 0})]                                            #Back to the HoursAgo function, we can add a ValidateScript that is either true or false, and if it's false the parameter is rejected
        [Parameter(Mandatory=$true)]
        [Int]$HoursInThePast
    )
    (Get-Date).AddHours(0 - $HoursInThePast)
}
HoursAgo 0
HoursAgo -HoursInThePast 10
HoursAgo -HoursInThePast -10

#-------------------------------------------
1..100                                                                          #1...x is still a fancy way to make a quick array of numbers 1 through x
$numbers = 1..100                                                               #Save to an array
function DisplayArray {                                                         #Create a function to Display the Array
    param([Array]$Array)                                                        #Parameter has to be an array
    $Array | ForEach-Object {                                                   #Array pipeline processing
        Write-Host '$_ is equal to', $_
    }
}
DisplayArray -Array $numbers                                                    #Displays what we want
DisplayArray -Array @(1,5,10,15,20)                                             #Created an array on the fly, but passed it in and the function processed it 

#-------------------------------------------
function SquareNumber {                                                         #Simple function to Square a Number
    param([Int]$number)                                                         #Takes 1 integer as a parameter
    
    return ($number*$number)                                                    #Multiplies the number by itself and then 'returns it'
}
SquareNumber -number 1
SquareNumber -number 2
SquareNumber -number 3

$newNumber = SquareNumber -Number 10                                            #We can save the 'return' from the function into a variable - just like we're used to doing with PowerShell cmdlets
$newNumber

#-------------------------------------------
function SquareNumber {                                                         #Functions can get complicated, so some looking at the internals generally becomes necessary
    param([Int]$number)
    
    Write-Host "Function is multiplying $number by $number"
    return ($number*$number)
}
SquareNumber -number 1
SquareNumber -number 2
SquareNumber -number 3

#-------------------------------------------
Get-Content .\README.md                                                         #Show the contents of the README file
Copy-Item -Path .\README.md -Destination .\README2.md                           #Copies the README.md to README2.md (probably? No news is good news)
Copy-Item -Path .\README.md -Destination .\README2.md -Verbose                  #Adding the -Verbose switch shows me what the function is doing

#-------------------------------------------
Write-Host 'This is great'
Write-Verbose "This is a verbose message"                                       #Why doesn't this work? (Checks $VerbosePreference)

function SquareNumber {                                                         #Same function as before
    [CmdletBinding()]                                                           #But now we've added CmdletBinding which adds -ErrorAction, -Verbose, etc as parameters
    param([Int]$number)
    
    Write-Verbose "Function is multiplying $number by $number"
    return ($number*$number)
}
SquareNumber -number 1                                                          #So now, nothing happens unless we -verbose switch
SquareNumber -number 2
SquareNumber -number 3
SquareNumber -number 10 -Verbose                                                #Now we can see the guts when we want to
$answer = SquareNumber -number 10 -Verbose

#-------------------------------------------
function SquareNumber {
    [CmdletBinding()]
    param([Int]$number)
    
    Write-Verbose "Function is multiplying $number by $number"
    $answer = $number*$number                                                           #Notice that the return line is removed.  The last line gets returned
}
SquareNumber -number 1
SquareNumber -number 2
SquareNumber -number 3
SquareNumber -number 10 -Verbose
$returnedValue = SquareNumber -number 100

#-------------------------------------------                                    #This is a long cmdlet call - ugly
Copy-Item -Path 'C:\users\Keith\github\PowerShell\README.md' -Destination 'C:\Users\Keith\github\PowerShell\README2.md' -Force -Verbose -ErrorAction 'SilentlyContinue'

$parameterHashTable = @{                                                        #This hashtable - in form @{ } allows us to specify our parameters
    Path        = 'C:\users\Keith\github\PowerShell\README.md'
    Destination = 'C:\Users\Keith\github\PowerShell\README2.md'
    Force       = $true
    Verbose     = $true
    ErrorAction = 'SilentlyContinue'
}
Copy-Item @parameterHashTable                                                   #We can then 'splat' all parameters to the cmdlet by saying @variableName instead of $VariableName (since $VariableName is a hashtable, while @ means 'please translate this into parameters')

#-------------------------------------------
Get-ChildItem -Recurse                                                          #Shows me my files in my current working directory
Get-ChildItem -Recurse | Select FullName                                        #Takes the list of files (array) and pipes them over to 'Select FullName'
Get-ChildItem -Recurse | Remove-Item -Recurse -WhatIf                           #Takes the list of files (array) and pipes them over to Remove-Item

Get-Help Remove-Item -Parameter Path                                            #"Accept pipeline input? True (ByValue is what matters here)

#-------------------------------------------
$Array = 1..5

function ShowProcessing {                                                       #Demonstration of a pipeline processing function
    param([Parameter(Mandatory=$true,ValueFromPipeline)]$Array)
    Begin {                                                                     #Begin runs once
        Write-Host 'function beginning'
    }
    Process {                                                                   #Process runs X number of times
        Write-Host $_
    }
    End {                                                                       #End runs once
        Write-Host 'function ending'
    }
}

ShowProcessing                                                                  #If you don't pass in anything, you don't get anything
$Array | ShowProcessing                                                         #Here, the array is processed one by one on the pipeline, and you get the expected results

#-------------------------------------------
$Array = 1..10

filter WriteDetailedLog {
    Write-Host "$(Get-Date): $_"
}

$Array | WriteDetailedLog
"Something went awry!" | WriteDetailedLog

#-------------------------------------------
function DisplayParameters ([int]$Number,[String]$String) {
    Write-Host "Number $Number"
    Write-Host "String $String"
}

DisplayParameters -Number 1 -String 'Keith'
DisplayParameters -Number 1
DisplayParameters -String 'Keith'

#-------------------------------------------
function DisplayParameters ([int]$Number,[String]$String) {
    Write-Host @PSBoundParameters
}
DisplayParameters
DisplayParameters -Number 1
DisplayParameters -Number 1 -String 'Keith'

#-------------------------------------------
function DisplayParameters ([int]$Number,[String]$String) {
    if($PSBoundParameters.ContainsKey('Number')) {
        Write-Host $Number
    }
    if($PSBoundParameters.ContainsKey('String')) {
        Write-Host $String
    }
}
DisplayParameters
DisplayParameters -Number 1
DisplayParameters -Number 1 -String 'Keith'

#Go look for PowerShell ParameterSets

