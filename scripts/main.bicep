param vmAdminUsername string
@secure()
param vmAdminPassword string
param sqlAdminUsername string
@secure()
param sqlAdminPassword string
param expiresOn string = '2021-11-17'


var environment = 'test'

var tags = {
  'Environment': environment
  'Usage': 'personal-use'
  'expiresOn': expiresOn
}

var sqlDbName = 'sql-db-failovertest-${environment}'
var sqlSrvName = 'sql-srv-failovertest-${environment}'


module vm 'appserver.bicep' = {
  name: 'TestFailOverVM'
  params:{
    environment: environment
    vmAdminUsername: vmAdminUsername
    vmAdminPassword: vmAdminPassword
    resourceTags: tags
  }
}


module sql 'sqlserver.bicep' = {
  name: '5msSql'
  params: {
    resourceTags: tags
    serverName: sqlSrvName
    databaseName: sqlDbName
    environment: environment
    adminPassword: sqlAdminPassword
    adminUsername: sqlAdminUsername
  }
}

