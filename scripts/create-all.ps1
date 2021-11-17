[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Location,

    [Parameter()]
    [string]
    $ResourceGroupName,

    [Parameter()]
    [string]
    $AdminUser,

    [Parameter()]
    [string]
    $AdminPassword

)
az group create -l $Location -g $ResourceGroupName
$expiresOn=((Get-Date).AddDays(1).ToString('yyyy-MM-dd'))
az deployment group create -g $ResourceGroupName --template-file .\main.bicep --parameters vmAdminUsername=$AdminUser vmAdminPassword=$AdminPassword sqlAdminUsername=$AdminUser sqlAdminPassword=$AdminPassword expiresOn=$expiresOn