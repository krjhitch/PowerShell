#Preamble - usually we see other code and it's polished, the troubleshooting tools are removed

#Important commands
    Get-Help
    Get-Command
    Get-Variable
    $Object.GetType()
    $Object.ToString()

#Quickly show how to use the basic help command -examples
    Update-Help                      #Update Help allows online machines to download the most up-to-date help files
    Get-Help                         #Explains how to use 'help' or 'Get-Help'
    Get-Help dir                     #Common way to get more information about the 'dir' command
    Get-Help Get-ChildItem -examples #Example of how to use Get-Help to get more information
                                     #PowerShell ISE 'Help->Show Command Window' is an interactive GUI version of Get-Help
    $PsVersionTable                  #This is a default variable that tells you the PowerShell version you are running
    $PsVersionTable.gettype()        #Shows that $PSVersionTable is a Hashtable variable
    Get-Variable                     #How do you know what variables are currently in memory? Get-Variable
    Remove-Variable             
    Get-Help Get-Variable -examples  #How can you explore ways to use Get-Variable? Get-Help
    Get-Command *variable*           #What other PowerShell commands deal with variables? Get-Command shows us



#Show to do variables
    #Discover what type of variable I have
                   $testVariable = dir c:\windows\temp #Variable = Command
                   $testVariable.gettype()             #All variables support the .gettype() method, which tells us what kind of variable they are
    #Basic int
                   $integerVariable = 8 #Common way to set an integer to a variable (should dynamically detect/save as an integer)
             [Int] $integerVariable = 8 #Common way to set an integer and be sure that it's an integer and not an object or a string
    [System.Int32] $integerVariable = 8 #Uncommon way to set an integer and be sure that it's 
    #Basic string
                   $stringVariable = 8   #As above, sets an integer                 
                   $stringVariable = '8' #Common way to set a string with the character 8 instead of the numeric value of 8
                   $stringVariable = "8" #Common way to set a string with the character 8 instead of the numeric value of 8
          [String] $stringVariable = 8   #Unlike above, the [String] means this variable will be a string so numeric 8 is converted to the character 8
   [System.String] $stringVariable = 8   #Again, sets the variable to the character 8

   #VERY Quick Pipeline Discussion
   #Example 1 - Same as example 2
   dir c:\windows\temp             #Displays results to the pipeline
   $results = dir c:\windows\temp  #Does not display anything, saves results to the $results variable
   $results.gettype()              #An array of objects - great
   #Example 2 - Same as example 1
   (dir c:\windows\temp).gettype() #Perform the code in the parenthesis first, but instead of displaying the results run the .gettype() method and display THAT

    #String Manipulation
        #Strings vs Ints
        $variableInteger = 8                       #Creates a variable with the integer value of 8
        $variableString = '8'                      #Creates a variable containing the character 8
        $variableInteger + $variableString         #Result - 16: The first variable is an integer so the values of both variables are converted to integers and their values are added 
        $variableString + $variableInteger         #Result - 88: The first variable is a string so the variables are appended together
        
        #'' vs ""
        $variableName = 'Keith'                    #Creates a string with the characters Keith
        '$variableName'                            #Results - $variableName: Single quotes mean DO NOT INTERPRET, string means LITERALLY what was written
        "$variableName"                            #Results - Keith: Double quotes mean please interpret PowerShell code and dynamically create my string
        "Hi my name is $variableName"              #Results - Hi my name is Keith
        "$variableName: please use PowerShell"     #Oops! Doesn't work because variable names can have : and PowerShell here thinks that the : is part of the variable and not the string (cannot find variable)
        "$($variableName): please use PowerShell"  #Wrapping our variable in $( ) makes it work since ( ) in PowerShell means 'do this first'.  The $ is required inside of a string so PowerShell understand you didn't literally mean 'put two parenthesis in my string'
        
        #Why is this useful?
        "My PowerShell Version is $PSVersionTable"              #Oops! Doeesn't work because $PSVersionTable is a Hashtable and too complicated ot automatically turn into a string
        $PSVersionTable.ToString()                              #All objects have a .ToString() method.  It shows us the object doesn't convert to a string well
        $PSVersionTable                                         #Show us that it's a hashtable.  We really care about $PSVersionTable.PSVersion
        $PSVersionTable.PSVersion                               #Great!
        $PSversionTalbe.PSVersion.GetType()                     #What kind of object is $PSVersionTabel.PSVersion? It looks like it's a [Version] object
        $PSVersionTable.PSVersion.ToString()                    #Result 5.1.14393.1198: This looks like it could go into a string
        "My PowerShell Version is $PSVersionTable.PSVersion"    #Oops! PowerShell thinks that .PSVersion is part of the string and not the variable 
        "My PowerShell Version is $($PSVersionTable.PSVersion)" #There we go.  That worked.  But that gets complicated looking, doesn't it?

        #.NET formatting 
        'My PowerShell Version is {0}'                                     #Single quotes - the string is exactly as written
        'My PowerShell Version is {0}' -f $PSVersionTable.PSVersion        #Single quotes BUT -f tells PowerShell to replace pattern {0} with the variable specified
        'My {1} Version is {0}' -f $PSVersionTable.PSVersion, 'PowerShell' #You can pass in multiple variables (in this case both PSVersion and a string with the word 'PowerShell') and it replaces {0} and {1} with the first and second variable specified

        #.split()
        'dnsname.domain.local'                        #Common string
        'dnsname.domain.local'.split('.')             #A [String] can use .split() and specify what to split on '.' in this case, but maybe ',' or '\'
        $results = 'dnsname.domain.local'.split('.')
        $results.gettype()                            #Oh look, it's an array of strings
        ('dnsname.domain.local'.split('.')).gettype() #Does not need to be saved to a variable first
                   
    #Basic array
        #Example 1 - Empty Array
        @()                   #Empty Array - You see nothing
        $results = @()        #Empty Array saved to a variable
        $results.GetType()    #What kind of variable is this? It's an [Array].  Technically it's an [Array] of [Object]s

        #Example 2 - Array of Numbers
        @(1,2,3)              #Displays the array
        $results = @(1,2,3)   #Saves the array to the variable $results
        $results              #Shows the array
        $results[0]           #Shows the value in the first index of the array.  [ ] denotes Index.  The value in the first Index (called Index 0) is the number 1
        $results[1]           #Shows the value in the second index of the array.  The value in the second index (Index 1) is the number 2
        $results[2]           #Shows the value in the third index of the array.  The value in the third index (Index 2) is the number 3
        $results[3]           #Ooops! Nothing was put in the fourth index of the array.  There is no value in the fourth index (Index 3)

        #Example 3 - Array of Strings
        @('Keith','Robert','Joseph','Hitchcock')             #Array of Names
        $results = @('Keith','Robert','Joseph','Hitchcock')  #Save array to $results variable
        "My Name is {0} {1}" -f $results[0], $results[3]     #Using string formatting we can select parts of the array to add to a string

        #Example 4 - Convert Array to String
        @('dnsname','domain','local')                        #Array of strings
        $results = @('dnsname','domain','local')             #Array of strings saved to the $results variable
        $results -join '.'                                   #The $results array can be -join'd to create a single string
        $singleString = $results -join '.'                   #The $results array can be -join'd and saved to a string ($singleString)
        $singleString.Gettype()                              #Proof that it's a string!

        @('192','168','0','1')                               #Same as above, but with numbers
        $results = @('192','168','0','1')
        $results -join '.'

    #Write-Host vs a [String]
        #String
        'Strings are great'              #Displays to your console. 
        ('Strings are great').gettype()  #Is a string!
        $result = 'Strings are great'    #Can be saved to a variable
        
        #Write-Host
        Write-Host 'Write-Host is great'             #Displays to your console
        (Write-Host 'Write-Host is great').gettype() #Oops! That doesn't work? 
        $result = Write-Host 'Write-Host is great'   #Displays to your console, but does it save?
        $result.gettype()                            #Oops! Write-Host didn't save anything to the variable

        #Write-Host ONLY displays to the user.  It does NOT put anything on the pipeline.  It cannot interact with variables.  It's output cannot be directed into other commands.
        #Write-Host is good for showing messages only

        #Split
        'www.microsoft.com'
        'www.microsoft.com'.split('.')
        'CN=Keith,OU=People,OU=Region,DC=domain,DC=local'.split(',')

    #Basic hashtable
    @{}
    @{'Name' = 'Value'}
    @{Name=Value}
    @{
        Name = Value
    }
    @{
        Name = Value;Name2 = Value2
    }
    @{
        Name = Value
        Name2 = Value2
    }
    $hashTable = @{
        FirstName = 'Keith'
        LastName = 'Hitchcock'
    }
    $hashTable.FirstName
    "My name is $hashTable.FirstName $hashTable.SecondName"
    "My name is $($hashTable.FirstName) $($hashTable.LastName)"

    1..10
    (1..10).gettype()
    $savedArray = 1..10
    $newHashTable = @{
        'Title' = 'This is my HashTable'
        'List' = $savedArray
    }
    $newHashTable.Title
    $newHashTable.List


#Moving around the filesystem
    #Fixed path
    cd c:\windows\temp
    Get-Command cd
    Set-Location C:\windows\Temp
    Set-Location \
    Set-Location C:\Windows\Temp
    Set-Location .
    Set-Location ..
    Set-Location ..\System32
    Set-Location ..\Temp\..\System32..\Temp\..System32..\..\

    Get-PSDrive
    Set-Location Cert:
    dir
    Get-Command dir
    Get-ChildItem
    cd CurrentUser
    cd my
    Get-ChildItem

#Cmdlet discovery and use
    #Discover cmdlets with Get-Command
    Get-Command *Firewall*
    #ISE Command Add-on
    Get-Help Get-NetFirewallRule
    #Example 2 - Get-NetFirewallProfile -Name Public | Get-NetFirewallRule

    
    Get-Command cp
    Get-Command Copy-Item

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
    #hwat is the pipeline?
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

#Show getting data out of IPConfig

#Extras - if we get time
    #ScriptBlock as Variable
    $scriptblock = {Write-Host 'Yay'}
    $scriptblock.Invoke()
#






