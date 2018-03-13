$jsonString = @'
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {
        "name": "Test",
        "location": "[parameter('location')]"
    },
    "resources": []
}
'@

$jsonObj = ConvertFrom-Json -InputObject $jsonString
$jsonObj | ConvertTo-Json