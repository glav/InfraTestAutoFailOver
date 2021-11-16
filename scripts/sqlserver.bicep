param environment string
param resourceTags object
param serverName string
param databaseName string
param adminUsername string = 'failovertest'
@secure()
param adminPassword string

// 2TB Gb for non prod, double that for prod

var storageAcctName = 'sa${environment}failoversqlaudit'

resource storageAcct 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAcctName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
  tags: resourceTags
}

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: serverName
  location: resourceGroup().location
  properties: {
    minimalTlsVersion: '1.2'
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
  }

  tags: resourceTags
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  name: '${sqlServer.name}/${databaseName}'
  location: resourceGroup().location
  tags: resourceTags
  sku: {
    name: 'GP_S_Gen5_2'
    tier: 'GeneralPurpose'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1677721600
    zoneRedundant: false
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    minCapacity: '0.5'
    autoPauseDelay: -1
    
  }
}



output sqlServerFullyQualifiedDomainName string = sqlServer.properties.fullyQualifiedDomainName
output sqlServerAdministratorLogin string = sqlServer.properties.administratorLogin
