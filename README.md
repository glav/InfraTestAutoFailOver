# InfraTestAutoFailOver
Simple repo mostly of automated infrastructure so I can test some auto fail over scenarios

### To Deploy
$rg="resourcegroupname"
$loc="AustrraliaEast"

$user="someuser"
$password="somesecurepassword"

az group create -l $loc -n $rg
$expiresOn=((Get-Date).AddDays(1).ToString('yyyy-MM-dd'))

az deployment group create -g $rg --template-file .\main.bicep --parameters vmAdminUsername=$user vmAdminPassword=$pwd sqlAdminUsername=$user sqlAdminPassword=$password expiresOn=$expiresOn
