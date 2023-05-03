param location string = 'eastus'
targetScope = 'Azure Pass - Sponsorship'


var rgName = 'myResourceGroup'
var vnetName = 'myVnet'
var subnet1Name = 'subnet1'
var subnet2Name = 'subnet2'
var vmWindowsName = 'myWindowsVM'
var vmLinuxName = 'myLinuxVM'
var vmAdminUsername = 'adminUser'
var vmAdminPassword = 'p@ssw0rd1234'

resource rgResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

resource vnetVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
  dependsOn: [
    rgResourceGroup
  ]
}

resource vmWindowsVirtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmWindowsName
  location: location
  dependsOn: [
    vnetVirtualNetwork
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
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
      }
    }
    osProfile: {
      computerName: vmWindowsName
      adminUsername: vmAdminUsername
      adminPassword: vmAdminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId(
            'Microsoft.Network/networkInterfaces',
            '${vmWindowsName}-nic'
          )
        }
      ]
    }
  }
}

resource nicWindowsNetworkInterface 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: '${vmWindowsName}-nic'
  location: location
  dependsOn: [
    vnetVirtualNetwork
  ]
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId(
              'Microsoft.Network/virtualNetworks/subnets',
              vnetVirtualNetwork.name,
              subnet1Name
            )
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vmLinuxVirtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmLinuxName
  location: location
  dependsOn: [
    vnetVirtualNetwork
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'}
      }
      osProfile: {
        computerName: vmWindowsName
        adminUsername: vmAdminUsername
        adminPassword: vmAdminPassword
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: resourceId(
              'Microsoft.Network/networkInterfaces',
              '${vmLinuxName}-nic'
            )
          }
        ]
      }
    }
  }
  resource nicLinuxNetworkInterface 'Microsoft.Network/networkInterfaces@2021-02-01' = {
    name: '${vmLinuxName}-nic'
    location: location
    dependsOn: [
      vnetVirtualNetwork
    ]
    properties: {
      ipConfigurations: [
        {
          name: 'ipconfig2'
          properties: {
            subnet: {
              id: resourceId(
                'Microsoft.Network/virtualNetworks/subnets',
                vnetVirtualNetwork.name,
                subnet2Name
              )
            }
            privateIPAllocationMethod: 'Dynamic'
          }
        }
      ]
    }
  }
  
