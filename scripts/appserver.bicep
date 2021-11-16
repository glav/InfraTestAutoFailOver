
param environment string
param resourceTags object

@minLength(5)
param vmAdminUsername string

@secure()
param vmAdminPassword string

var storageAcctName = 'sa${environment}testfailover'


// If prod, use global redundant storage otherwise use local redundant storage
var saAcctType = 'Standard_LRS'
var vmSize = 'Standard_D4s_v4'

// resources


resource nicvm 'Microsoft.Network/networkInterfaces@2020-05-01' = {
  name: 'nic-testfailover'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'nic-config1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
  tags: resourceTags
}

resource storageAcct 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAcctName
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: saAcctType
  }
  properties: {
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
  tags: resourceTags
}

var vmName='testfailover${environment}'
resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: vmName
  location: resourceGroup().location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: vmAdminUsername
      adminPassword: vmAdminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: false
        timeZone: 'AUS Eastern Standard Time'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicvm.id
          properties: {
            primary: true
          }
        }
      ]
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: storageAcct.properties.primaryEndpoints.blob
      }
    }
  }
  tags: resourceTags
}

