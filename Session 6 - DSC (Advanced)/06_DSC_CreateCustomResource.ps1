Find-Module *designer*
Install-Module xDSCResourceDesigner

Get-Command -Module xDSCResourceDesigner

Get-Help New-xDSCResource -examples
Get-Help New-xDscResourceProperty -examples

#Create Parameter 1
$params = @{
    Name        = 'DriveLetter'
    Type        = 'String'
    Attribute   = 'Key'
    ValidateSet = 'C','D','E'
    Description = 'This is the drive letter to be used'
}
$driveLetterProperty = New-xDscResourceProperty @params

$driveLetterProperty

#Create Parameter 2
$params = @{
    Name        = 'FileSystemLabel'
    Type        = 'String'
    Attribute   = 'Write'
    Description = 'This is the filesystem label'
}
$fileSystemLabelProperty = New-xDscResourceProperty @params

$fileSystemLabelProperty

#Validate Parameters
$driveLetterProperty, $fileSystemLabelProperty | Format-Table

#Create Custom Resource Outline
$params = @{
    Name         = 'xDscDriveLabel'
    Property     = $driveLetterProperty, $fileSystemLabelProperty
    ClassVersion = '1.0'
    ModuleName   = 'xDSCDriveOperations'
    Path         = 'C:\Program Files\WindowsPowerShell\Modules'
}
New-xDSCResource @params

#Verify what was created
Get-ChildItem 'C:\Program Files\WindowsPowerShell\Modules\xDscDriveOperations'
Get-ChildItem 'C:\Program Files\WindowsPowerShell\Modules\xDscDriveOperations\DSCResources'
Get-ChildItem 'C:\Program Files\WindowsPowerShell\Modules\xDscDriveOperations\DSCResources\xDscDriveLabel'
psedit 'C:\Program Files\WindowsPowerShell\Modules\xDscDriveOperations\DSCResources\xDscDriveLabel\*'

#Build Configuration
configuration 'TestTest' {
    Import-DscResource -ModuleName xDSCDriveOperations

    node 'localhost' {
        xDscDriveLabel 'CDrive' {
            DriveLetter     = 'C'
            FileSystemLabel = 'DSCRocks'
        }
    }
}

TestTest
psedit .\TestTest\localhost.mof
