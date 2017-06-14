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
        "$variableName`: please use PowerShell"    #I can also 'escape' the : by using the PowerShell escape character which is ` (the backtick)

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
        'www.microsoft.com'                                              #Single [String]
        'www.microsoft.com'.split('.')                                   #Single [String] using the .split command (which also takes in a string) - the delimiter is .   Result is that you get an array with 3 elements
        'CN=Keith,OU=People,OU=Region,DC=domain,DC=local'.split(',')     #A practical (more common) string that you might see
        'CN=Keith,OU=People,OU=Region,DC=domain,DC=local'.split(',')[0]  #The first element, which is CN=Keith

        #Replace
        'My name is Keith Hitchcock' -replace 'Keith Hitchcock','Mr. PowerShell'

    #Basic hashtable
    @{}                                 #The basic syntax for an empty hashtable
    @{'Key' = 'Value or Variable'}      #The basic syntax for a hashtable with 1 Key/Value
    @{Name=Value}                       #Another valid syntax for a hashtable, the Key/Value is assumed to be strings

    @{                                  #Common multi-line formatting for hashtables
        Name = Value
    }

    @{                                  #A hashtable with 2 keys.  Hashtables keys can be seperated by either ; or a new line
        Name = Value;Name2 = Value2
    }

    @{                                  #Another hashtable with 2 keys.  These are seperated with a new line
        Name = Value
        Name2 = Value2
    }

    $hashTable = @{                      #An example of a real hashtable and why it might be useful.  Instead of [0] and [1], I can say $variable.FirstName and $variable.LastName to get my values
        FirstName = 'Keith'
        LastName = 'Hitchcock'
    }
    $hashTable.FirstName                
    "My name is $hashTable.FirstName $hashTable.SecondName"
    "My name is $($hashTable.FirstName) $($hashTable.LastName)"

    1..10                                #The .. in PowerShell represents a series.  It is the same as typing 1,2,3,4,5,6,7,8,9,10
    (1..10).gettype()
    $savedArray = 1..10

    $newHashTable = @{                   #This hashtable has one key (Title) with a string value and one key (List) with an array as the value
        'Title' = 'This is my HashTable'
        'List' = $savedArray
    }
    $newHashTable.Title
    $newHashTable.List


#Moving around the filesystem
    #Fixed path
    pwd                                  #PWD shows your current location on a drive
    Get-Command pwd                      #Turns out, pwd is actually an alias for the Get-Location cmdlet
    Get-Location                         #Get-Location also shows your current location on a drive
    cd c:\windows\temp                   #cd (Change Directory) changes the current location to c:\windows\temp
    Get-Command cd                       #Get-Command shows us that cd is really an alias for the Set-Location cmdlet
    Set-Location C:\windows\Temp         #Set-Location changes our directory to c:\windows\temp
    Set-Location \                       #In filesystems, \ represents the root of the current drive.  So if you're anywhere on C: you'll go back to C:\, if you're on D: anywhere you'll go back to D:\
    Set-Location C:\Windows\Temp         

    #Relative Path
    Set-Location .                             #. is the current directory.  This command (doesn't do much) moves you to the directory you're already in
    Set-Location ..                            #.. is the current parent directory.  This command moves you one directory back on the drive (the parent folder)
    Set-Location .\System32                    #.\System32 means- In the current folder (.) there should be a subfolder named System32 (and move to it)
    Set-Location ..\Temp\..\System32\..\Temp   #This one gets complicated (but it works)

    Get-PSDrive                           #Shows some of the great PSDrives that you can use.  Cert, HKLM, and WSMAN are great ones 
    Set-Location Cert:                    #An example of moving the current working directory to the CERT: PSDRIVE
    dir                                   #Dir (which is an alias for the Get-ChildItem cmdlet) shows us the certs/folders that are in the CERT: drive
    Get-Command dir                       #alias for the Get-ChildItem cmdlet)
    Get-ChildItem                         #shows us the certs/folders that are in the CERT: drive    
    cd CurrentUser                        #cd (Set-Location) to the CurrentUser folder
    cd my                                 #cd (Set-Location) to the My folder
    Get-ChildItem                         #These are the PowerShell objects that represent the current user's certificates

#Cmdlet discovery and use
    #Discover cmdlets with Get-Command
    Get-Command *Firewall*
    #ISE Command Add-on
    Get-Help Get-NetFirewallRule
    #Example 2 - Get-NetFirewallProfile -Name Public | Get-NetFirewallRule

    Get-Command cp                                                       #cp is the alias for the Copy-Item Cmdlet
    Copy-Item 'WER935.tmp.txt' 'WER935.txt'                              #Copy-Item works, the source and the destination both work
    Get-Command del                                                      #del is the alias for the Remove-Item cmdlet
    Remove-Item 'WER935.txt'                                             #Remove-Item also works (no surprises there)
    Copy-Item 'WER935.tmp.txt' 'WER935.txt' -Verbose                     #Most cmdlets have the -Verbose switch parameter, which means that it will show what it is doing
    Get-Help Copy-Item -Full                                             #How do you use the Copy-Item cmdlet? How is Copy-Item <source> <destination> working? How can we be more explicit?
                                                                         #Look for Parameter Position 0 (-Path) and Parameter Position 1 (-Destination)
    Copy-Item -Path 'WER935.tmp.txt' -Destination 'WER935.txt' -Verbose  #Command does the exact same thing, but now it's easier to read
    
    Get-Item -Path 'WER935.txt'                                          #Get-Item (from current directory, since no full path was specified)
    $fileObject = Get-Item -Path 'WER935.txt'                            #Get-Item but save it to a variable (notice that the console output disappeared)
    Get-Variable 'saved'                                                 #No such variable
    Get-Item -Path 'WER935.txt' -OutVariable saved                       #the -OutVariable parameter saves the output to a variable, but it's also displayed to the screen
    $saved                                                               #Proof that the $saved variable was create and has an object in it

#Objects as variables
    $fileObject = Get-Item -Path 'WER935.txt'                           #Get a file object and save it to a variable
    $fileObject                                                         #Proof that the object is saved
    $fileObject | Format-List                                           #When we pipe an object to Format-List it shows us more properties of the object than just calling the object
    $fileObject | Format-List *                                         #Format-List * shows us yet more properties
    $fileObject | Format-List * -Force
    $fileObject | Get-Member 
    $fileObject
    $fileObject.Name
    $fileObject.BaseName
    $fileObject.Extension
    $fileObject.FullName
    $fileObject | Get-Member 
    "This is a string that represents $fileObject"
    "This is a string that represents $PSVersionTable"
    $fileObject.ToString()
    $PSVersionTable.ToString()
    
    $PSVersionTable.GetType()
    $PSVersionTable 
    $PSVersionTable.PSVersion.ToString()

#Control Structure
    # ( ) Order of Operations
    $fileObject = Get-Item -Path 'WER935.txt'
    $fileObject.Extension

    (Get-Item -Path 'WER935.txt').Extension

    # () Order of Operations in a string
    "The file extension is $((Get-Item -Path 'WER935.txt').Extension)"
    #if
    if ($true) {
        Write-Host '$true is always True!'
    }

    if (-not $true) {
        Write-Host 'You should never see this'
    }

    if (1 -eq 1) {
        Write-Host 'True!'
    }

    $true.gettype()
    $false.gettype()
    #ForEach vs Pipeline
    $list = 1..20
    $list

    ForEach ($item in $list) {
        Write-Host $item
    }

    $list | ForEach-Object {
        Write-Host $_
    }

   #$LASTEXITCODE IS FOR EXEs, $? is for PowerShell
   Get-Variable $LASTEXITCODE
   ipconfig.exe
   $LASTEXITCODE
   ipconfig.exe /fakeswitch
   $LASTEXITCODE

   Get-Process 
   $?
   Get-Process -Name 'fakeprocess'
   $?
   $?

#Pipeline passing of objects and outputs
    #What is the pipeline?
    #Why are objects better than text?
    (Get-ChildItem -Path C:\Windows\Temp).Extension
    Get-ChildItem | Out-GridView #ISE Only
    ipconfig.exe
    $result = ipconfig.exe
    $result | Get-Member
    (ipconfig.exe) -match "IP"
    $result = (ipconfig.exe) -match "IP"

    $result | ForEach-Object {
        $_.split(':')
    }

    $result | ForEach-Object {
        $_.split(':')[1]
    }

    $ipaddresses = $result | ForEach-Object {
        $_.split(':')[1]
    }

    $result | ForEach-Object {
        $_.split(':')[1]
    } | Clip

    $result | ForEach-Object {
        $_.split(':')[1]
    } | Out-File -FilePath .\ipaddresses.txt


    # | Out-File
    # | Out-CSV
    Get-ChildItem C:\Windows\Temp
    $files = Get-ChildItem C:\Windows\Temp
    $files | Out-GridView
    $files | Out-File -Path c:\temp.txt
    psedit c:\temp.txt
    $files | Out-CSV -Path c:\tempcsv.csv
    psedit c:\tempcsv.csv

#Extras
    #ScriptBlock as Variable
    $scriptblock = {Write-Host 'Yay'}
    $scriptblock.Invoke()
#






