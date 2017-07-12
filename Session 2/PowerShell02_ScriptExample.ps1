[CmdletBinding()]
param(
    [ValidateScript({$_ -gt 0})]
    [Parameter(Mandatory=$true)]
    [Int]$Number1,
    [ValidateScript({$_ -lt 0})]
    [Parameter(Mandatory=$true)]
    [Int]$Number2
)
$answer = $Number1 * $Number2
Write-Verbose "Multiplying $Number1 by $Number2, result = $answer"

return $answer
