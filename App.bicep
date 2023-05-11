param webAppName string = uniqueString((resourceGroup().id))
param sku string = 'B1'
param linuxFixVersion string = 'php|7.4'
param location string = resourceGroup().location

var appServicePlanName = toLower('AppServicePlan')
var webSiteName = toLower('wapp-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location:location
  sku: {
    name:sku
  }
  kind:'linux'
  properties:{
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name:webSiteName
  location:location
  kind:'app'
  properties:{
    serverFarmId: appServicePlan.id
  
  siteConfig: {
 linuxFiXVersion :linuxFixVersion
  }
}
}

