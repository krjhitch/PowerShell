#Quickly show how to use the basic help command -examples
    Update-Help
    Get-Help

#Show to do variables
    #Basic int
    #Basic string
    #Basic array
    #Basic hashtable
    #Show alternate assignment techniques (empty arrays, etc)
    #Show .gettype() and [casting] - perhaps an example with 1 + 1
    #Show Get-Variable
    #Show variable $(names) and show variable $scopes:etc
    #Explain when to save a variable

#String Manipulation
    #Adding strings
    #'' vs ""
    #Hashtable sections in a string
    #.NET formatting
    #Invoke-Expression
    #.split()

#Array Manipulation
    #-Join, -Split
    #$a + $a vs $a += 'x'

#Moving around the filesystem
    #Fixed path
    #Relative path
    #Relative path madness
    #Other 'Drives' like hklm: cert:
    #.\sourcing

#Cmdlet discovery and use
    #Discover cmdlets with Get-Command
    #Discover aliases with Get-Alias
    #Get-Help and command add-on
    #Copy-Item explain -verbose
    #Out-Variable

#Objects as variables
    #Assigning and using/reusing objects
    #Cmdlets for pipeline vs saved to a variable
    #Looiking at objects | 

#Control Structure
    #Order of operations ( ) code to evaluate
    #if
    #ForEach vs Pipeline
    #Pipeline me some files    
    #$_ and $? and $LASTEXITCODE

#Pipeline passing of objects and outputs
    #hwat is the pieline?
    #What is an object?
    #Why are objects better than text?
    #How do I look at my object?
    # | Get-Member
    # | Format-Table
    # | Format-List
    #.gettype() again
    #.toString()
    # | Out-File
    # | Out-CSV
    # | OGV
    # | Clip

#Extras - if we get time
    #ScriptBlock as Variable
    $scriptblock = {Write-Host 'Yay'}
    $scriptblock.Invoke()
#






