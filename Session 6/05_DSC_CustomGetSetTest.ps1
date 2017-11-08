#Drive Volume FileSystemLabel
function Get {
    param([Char]$DriveLetter)

    return [HashTable]@{
        DriveLetter     = $DriveLetter
        FileSystemLabel = (Get-Volume -DriveLetter $DriveLetter).FileSystemLabel
    }
}

function Set {
    param(
          [Char]   $DriveLetter,
          [String] $FileSystemLabel
    )

    Set-Volume -DriveLetter $DriveLetter -NewFileSystemLabel $FileSystemLabel
}

function Test {
    param(
          [Char]   $DriveLetter,
          [String] $FileSystemLabel
    )

    (Get-Volume -DriveLetter $DriveLetter).FileSystemLabel -eq $FileSystemLabel
}
