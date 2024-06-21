param location string = resourceGroup().location
param adminUsername string = 'azureuser'
@secure()
param adminPassword string
param applicationGateWayName string = 'appGateway-Dev'
@description('Size of the virtual machine.')
param vmSize string = 'Standard_B2ms'
@description('The name of the SQL logical server.')
param sqlServerName string = uniqueString('sql', resourceGroup().id)
@description('The name of the SQL Database.')
param sqlDBName string = 'DB-dev'
param tenantId string = subscription().tenantId
@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.')
param enabledForDeployment bool = false
@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
param enabledForDiskEncryption bool = false
@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool = false
var GWPip = 'GWPip'
var virtualMachineName = 'myVM'
var networkInterfaceName = 'nic'
var ipconfigName = 'ipconfig'
var spokeVNetName = 'spokeVNet'
var nsgName = 'vm-nsg'


// Virtual Networks
resource vnet1 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

