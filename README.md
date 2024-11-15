<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable-file MD033 MD012 -->
# terraform-azurerm-easy-brick-network-vnet
LederWorks Easy Azure VNET Brick Module

This module were created by [LederWorks](https://lederworks.com) IaC enthusiasts.

## About This Module
This module implements the [VNET](https://lederworks.com/docs/microsoft-azure/bricks/network/#vnet) reference Insight.

## How to Use This Modul
- Ensure Azure credentials are [in place](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure) (e.g. `az login` and `az account set --subscription="SUBSCRIPTION_ID"` on your workstation)
- Owner role or equivalent is required!
- Ensure pre-requisite resources are created.
- Create a Terraform configuration that pulls in this module and specifies values for the required variables.

## Feature Registrations

### VNET encryption
With azcli:

```
az feature register --namespace Microsoft.Network --name EnableVNetEncryption
az feature show --namespace Microsoft.Network --name EnableVNetEncryption
az provider register -n Microsoft.Network
```

With terraform:

```
resource "azurerm_subscription_feature" "vnet_encryption" {
  feature_name = "EnableVNetEncryption"
  provider_namespace = "Microsoft.Network"
}
```

## Disclaimer / Known Issues
- Disclaimers
- Known Issues

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=1.3.4)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 4.9.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 4.9.0)

## Examples

### Just give me a new VNET

```hcl
module "network-vnet" {
  source  = "LederWorks/easy-brick-network-vnet/azurerm"
  version = "X.X.X"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.example

  #Tags
  tags = local.tags

  #Global Variables
  vnet_deploy = true
  vnet_name                         = "example"
  vnet_address_space                = ["10.0.0.0/16", "172.20.0.0/26"]
  vnet_dns_servers                  = ["4.4.4.4", "8.8.8.8"]
  vnet_edge_zone                    = ""
  vnet_bgp                          = ""
  vnet_ddos_protection_plan_enabled = true
  vnet_ddos_protection_plan_id      = ""
  vnet_encryption_state             = "AllowUnencrypted"

  #Local Variables
  vnet_default_subnets = {

    bastion = {
      name                                          = "AzureBastionSubnet"
      address_prefixes                              = ["172.20.0.0/26"]
    }

    default1 = {
      name                                          = "default1"
      address_prefixes                              = ["10.0.0.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.KeyVault"]
      delegation = {
        nic = {
          delegation_name = "nic"
          service_name = "Microsoft.Web/serverFarms"
          service_action = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }
    }

    default2 = {
      name                                          = "default2"
      address_prefixes                              = ["10.0.1.0/24"]
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    }
  }

  vnet_additional_subnets = {}

  vnet_custom_subnets = {}

}
```

### Existing VNET with [cidrsubnet](https://developer.hashicorp.com/terraform/language/functions/cidrsubnet) function

```hcl
locals {
  vnet_range = "10.0.0.0/16"
  subnet_ranges = cidrsubnet(local.vnet_range,
  4,4,4,4, #10.0.0.0/18
  4,4,4,4, #10.0.64.0/18
  4,4,4,4, #10.0.128.0/18
  4,4,4,4, #10.0.192.0/18
  )
}

module "network-vnet" {
  source  = "LederWorks/easy-brick-network-vnet/azurerm"
  version = "X.X.X"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.example

  #Global Variables
  vnet_object = azurerm_virtual_network.example

  #Local Variables
  vnet_default_subnets = {
    default1 = {
      name                                          = "default1"
      address_prefixes                              = [local.subnet_ranges[0]]
    }

    default2 = {
      name                                          = "default2"
      address_prefixes                              = [local.subnet_ranges[1]]
    }
  }

  vnet_additional_subnets = {
    additional1 = {
      name                                          = "additional1"
      address_prefixes                              = [local.subnet_ranges[5]]
    }

    additional2 = {
      name                                          = "additional2"
      address_prefixes                              = [local.subnet_ranges[6]]
    }
  }

  vnet_custom_subnets = {
    custom1 = {
      name                                          = "custom1"
      address_prefixes                              = [local.subnet_ranges[9]]
    }

    custom2 = {
      name                                          = "custom2"
      address_prefixes                              = [local.subnet_ranges[10]]
    }
  }
  
}
```

## Resources

The following resources are used by this module:

- [azurerm_subnet.additional_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.custom_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_subnet.default_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_virtual_network_dns_servers.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_dns_servers) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_resource_group_object"></a> [resource\_group\_object](#input\_resource\_group\_object)

Description: (Required) Resource Group Object

Type: `any`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: (Required) ID of the Subscription

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Your Azure tags, as a map(string)

Type: `map(string)`

Default: `null`

### <a name="input_vnet_additional_subnets"></a> [vnet\_additional\_subnets](#input\_vnet\_additional\_subnets)

Description:     <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) A map of custom Subnets to create.

    `name`                                          - (Required) The name of the subnet. Changing this forces a new resource to be created.

    `address_prefixes`                              - (Required) The address prefixes to use for the subnet.

    `private_endpoint_network_policies`             - (Optional) Enable or Disable network policies for the private endpoint on the subnet.  
                                                      Possible values are Disabled, Enabled, NetworkSecurityGroupEnabled and RouteTableEnabled. Defaults to Disabled.

                                                      NOTE: If you don't want to use network policies like user-defined Routes and Network Security Groups, you need to set _private\_link\_service\_network\_policies\_enabled_ in the subnet to Disabled.  
                                                      This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet.  
                                                      For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the _azurerm\_subnet\_network\_security\_group\_association_ resource.

                                                      NOTE: If you want to use network policies like user-defined Routes and Network Security Groups, you need to set the _private\_link\_service\_network\_policies\_enabled_ in the Subnet to Enabled/NetworkSecurityGroupEnabled/RouteTableEnabled.  
                                                      This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet.  
                                                      For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the _azurerm\_subnet\_network\_security\_group\_association_ resource.

                                                      For more details check: https://learn.microsoft.com/en-gb/azure/private-link/disable-private-endpoint-network-policy?tabs=network-policy-portal.

    `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to true.

                                                      NOTE: When configuring Azure Private Link service, the explicit setting _private\_link\_service\_network\_policies\_enabled_ must be set to false in the subnet since Private Link Service does not support network policies like user-defined Routes and Network Security Groups.  
                                                      This setting only affects the Private Link service. For other resources in the subnet, access is controlled based on the Network Security Group which can be configured using the _azurerm\_subnet\_network\_security\_group\_association_ resource.  
                                                      For more details check: https://learn.microsoft.com/en-gb/azure/private-link/disable-private-link-service-network-policy?tabs=private-link-network-policy-powershell.

    `service_endpoints`                             - (Optional) The list of Service endpoints to associate with the subnet. Possible values include:
                                                        - Microsoft.AzureActiveDirectory
                                                        - Microsoft.AzureCosmosDB
                                                        - Microsoft.ContainerRegistry
                                                        - Microsoft.EventHub, Microsoft.KeyVault
                                                        - Microsoft.ServiceBus
                                                        - Microsoft.Sql
                                                        - Microsoft.Storage
                                                        - Microsoft.Storage.Global
                                                        - Microsoft.Web

                                                      In order to use Microsoft.Storage.Global service endpoint (which allows access to virtual networks in other regions), you must enable the AllowGlobalTagsForStorage feature in your subscription.  
                                                      For more details check https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-cli#enabling-access-to-virtual-networks-in-other-regions-preview.

    `service_endpoint_policy_ids`                   - (Optional) A list of Service Endpoint Policy IDs to associate with the subnet.

    `delegation` - (Optional) A list of subnet delegation objects.

      `delegation_name` - (Required) A name for this delegation.

      `service_name`    - (Required) The name of service to delegate to. Possible values are:
                            - GitHub.Network/networkSettings
                            - Microsoft.ApiManagement/service
                            - Microsoft.Apollo/npu
                            - Microsoft.App/environments, Microsoft.App/testClients
                            - Microsoft.AVS/PrivateClouds
                            - Microsoft.AzureCosmosDB/clusters
                            - Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers
                            - Microsoft.Batch/batchAccounts
                            - Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, Microsoft.CloudTest/pools
                            - Microsoft.Codespaces/plans
                            - Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients
                            - Microsoft.Databricks/workspaces
                            - Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, Microsoft.DBforMySQL/serversv2
                            - Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers
                            - Microsoft.DelegatedNetwork/controller
                            - Microsoft.DevCenter/networkConnection
                            - Microsoft.DocumentDB/cassandraClusters
                            - Microsoft.Fidalgo/networkSettings-
                            - Microsoft.HardwareSecurityModules/dedicatedHSMs
                            - Microsoft.Kusto/clusters
                            - Microsoft.LabServices/labplans
                            - Microsoft.Logic/integrationServiceEnvironments
                            - Microsoft.MachineLearningServices/workspaces
                            - Microsoft.Netapp/volumes
                            - Microsoft.Network/dnsResolvers, Microsoft.Network/fpgaNetworkInterfaces, Microsoft.Network/networkWatchers, Microsoft.Network/virtualNetworkGateways
                            - Microsoft.Orbital/orbitalGateways
                            - Microsoft.PowerPlatform/enterprisePolicies, Microsoft.PowerPlatform/vnetaccesslinks
                            - Microsoft.ServiceFabricMesh/networks
                            - Microsoft.ServiceNetworking/trafficControllers
                            - Microsoft.Singularity/accounts/networks, Microsoft.Singularity/accounts/npu
                            - Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest
                            - Microsoft.StoragePool/diskPools
                            - Microsoft.StreamAnalytics/streamingJobs
                            - Microsoft.Synapse/workspaces
                            - Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms
                            - NGINX.NGINXPLUS/nginxDeployments
                            - PaloAltoNetworks.Cloudngfw/firewalls
                            - Qumulo.Storage/fileSystems

      `service_action`  - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are:
                            - Microsoft.Network/networkinterfaces/*
                            - Microsoft.Network/publicIPAddresses/join/action
                            - Microsoft.Network/publicIPAddresses/read
                            - Microsoft.Network/virtualNetworks/read
                            - Microsoft.Network/virtualNetworks/subnets/action
                            - Microsoft.Network/virtualNetworks/subnets/join/action
                            - Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action
                            - Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action

Type:

```hcl
map(object({
    name                                          = string
    address_prefixes                              = set(string)
    default_outbound_access_enabled               = optional(bool, true)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(set(string))
    delegation = optional(map(object({
      delegation_name = optional(string)
      service_name    = optional(string)
      service_action  = optional(list(string))
    })))
  }))
```

Default: `null`

### <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space)

Description: (Optional) The address space that is used for the new VNET. You can supply more than one address space.

Type: `set(string)`

Default: `null`

### <a name="input_vnet_bgp"></a> [vnet\_bgp](#input\_vnet\_bgp)

Description: (Optional) The BGP community attribute in format <as-number>:<community-value> for the new VNET. The as-number segment is the Microsoft ASN, which is always 12076 for now.

Type: `string`

Default: `null`

### <a name="input_vnet_custom_subnets"></a> [vnet\_custom\_subnets](#input\_vnet\_custom\_subnets)

Description:     <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) A map of custom Subnets to create.

    `name`                                          - (Required) The name of the subnet. Changing this forces a new resource to be created.

    `address_prefixes`                              - (Required) The address prefixes to use for the subnet.

    `private_endpoint_network_policies`             - (Optional) Enable or Disable network policies for the private endpoint on the subnet.  
                                                      Possible values are Disabled, Enabled, NetworkSecurityGroupEnabled and RouteTableEnabled. Defaults to Disabled.

                                                      NOTE: If you don't want to use network policies like user-defined Routes and Network Security Groups, you need to set _private\_link\_service\_network\_policies\_enabled_ in the subnet to Disabled.  
                                                      This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet.  
                                                      For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the _azurerm\_subnet\_network\_security\_group\_association_ resource.

                                                      NOTE: If you want to use network policies like user-defined Routes and Network Security Groups, you need to set the _private\_link\_service\_network\_policies\_enabled_ in the Subnet to Enabled/NetworkSecurityGroupEnabled/RouteTableEnabled.  
                                                      This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet.  
                                                      For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the _azurerm\_subnet\_network\_security\_group\_association_ resource.

                                                      For more details check: https://learn.microsoft.com/en-gb/azure/private-link/disable-private-endpoint-network-policy?tabs=network-policy-portal.

    `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to true.

                                                      NOTE: When configuring Azure Private Link service, the explicit setting _private\_link\_service\_network\_policies\_enabled_ must be set to false in the subnet since Private Link Service does not support network policies like user-defined Routes and Network Security Groups.  
                                                      This setting only affects the Private Link service. For other resources in the subnet, access is controlled based on the Network Security Group which can be configured using the _azurerm\_subnet\_network\_security\_group\_association_ resource.  
                                                      For more details check: https://learn.microsoft.com/en-gb/azure/private-link/disable-private-link-service-network-policy?tabs=private-link-network-policy-powershell.

    `service_endpoints`                             - (Optional) The list of Service endpoints to associate with the subnet. Possible values include:
                                                        - Microsoft.AzureActiveDirectory
                                                        - Microsoft.AzureCosmosDB
                                                        - Microsoft.ContainerRegistry
                                                        - Microsoft.EventHub, Microsoft.KeyVault
                                                        - Microsoft.ServiceBus
                                                        - Microsoft.Sql
                                                        - Microsoft.Storage
                                                        - Microsoft.Storage.Global
                                                        - Microsoft.Web

                                                      In order to use Microsoft.Storage.Global service endpoint (which allows access to virtual networks in other regions), you must enable the AllowGlobalTagsForStorage feature in your subscription.  
                                                      For more details check https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-cli#enabling-access-to-virtual-networks-in-other-regions-preview.

    `service_endpoint_policy_ids`                   - (Optional) A list of Service Endpoint Policy IDs to associate with the subnet.

    `delegation` - (Optional) A list of subnet delegation objects.

      `delegation_name` - (Required) A name for this delegation.

      `service_name`    - (Required) The name of service to delegate to. Possible values are:
                            - GitHub.Network/networkSettings
                            - Microsoft.ApiManagement/service
                            - Microsoft.Apollo/npu
                            - Microsoft.App/environments, Microsoft.App/testClients
                            - Microsoft.AVS/PrivateClouds
                            - Microsoft.AzureCosmosDB/clusters
                            - Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers
                            - Microsoft.Batch/batchAccounts
                            - Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, Microsoft.CloudTest/pools
                            - Microsoft.Codespaces/plans
                            - Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients
                            - Microsoft.Databricks/workspaces
                            - Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, Microsoft.DBforMySQL/serversv2
                            - Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers
                            - Microsoft.DelegatedNetwork/controller
                            - Microsoft.DevCenter/networkConnection
                            - Microsoft.DocumentDB/cassandraClusters
                            - Microsoft.Fidalgo/networkSettings-
                            - Microsoft.HardwareSecurityModules/dedicatedHSMs
                            - Microsoft.Kusto/clusters
                            - Microsoft.LabServices/labplans
                            - Microsoft.Logic/integrationServiceEnvironments
                            - Microsoft.MachineLearningServices/workspaces
                            - Microsoft.Netapp/volumes
                            - Microsoft.Network/dnsResolvers, Microsoft.Network/fpgaNetworkInterfaces, Microsoft.Network/networkWatchers, Microsoft.Network/virtualNetworkGateways
                            - Microsoft.Orbital/orbitalGateways
                            - Microsoft.PowerPlatform/enterprisePolicies, Microsoft.PowerPlatform/vnetaccesslinks
                            - Microsoft.ServiceFabricMesh/networks
                            - Microsoft.ServiceNetworking/trafficControllers
                            - Microsoft.Singularity/accounts/networks, Microsoft.Singularity/accounts/npu
                            - Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest
                            - Microsoft.StoragePool/diskPools
                            - Microsoft.StreamAnalytics/streamingJobs
                            - Microsoft.Synapse/workspaces
                            - Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms
                            - NGINX.NGINXPLUS/nginxDeployments
                            - PaloAltoNetworks.Cloudngfw/firewalls
                            - Qumulo.Storage/fileSystems

      `service_action`  - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are:
                            - Microsoft.Network/networkinterfaces/*
                            - Microsoft.Network/publicIPAddresses/join/action
                            - Microsoft.Network/publicIPAddresses/read
                            - Microsoft.Network/virtualNetworks/read
                            - Microsoft.Network/virtualNetworks/subnets/action
                            - Microsoft.Network/virtualNetworks/subnets/join/action
                            - Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action
                            - Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action

Type:

```hcl
map(object({
    name                                          = string
    address_prefixes                              = set(string)
    default_outbound_access_enabled               = optional(bool, true)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(set(string))
    delegation = optional(map(object({
      delegation_name = optional(string)
      service_name    = optional(string)
      service_action  = optional(list(string))
    })))
  }))
```

Default: `null`

### <a name="input_vnet_ddos_protection_plan_enabled"></a> [vnet\_ddos\_protection\_plan\_enabled](#input\_vnet\_ddos\_protection\_plan\_enabled)

Description: (Optional) Enable or Disable DDOS protection plan for the new VNET.

Type: `bool`

Default: `false`

### <a name="input_vnet_ddos_protection_plan_id"></a> [vnet\_ddos\_protection\_plan\_id](#input\_vnet\_ddos\_protection\_plan\_id)

Description: (Optional) DDoS Protection plan ID for the new VNET.

Type: `string`

Default: `null`

### <a name="input_vnet_default_subnets"></a> [vnet\_default\_subnets](#input\_vnet\_default\_subnets)

Description:     <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) A map of custom Subnets to create.

    `name`                                          - (Required) The name of the subnet. Changing this forces a new resource to be created.

    `address_prefixes`                              - (Required) The address prefixes to use for the subnet.

    `private_endpoint_network_policies`             - (Optional) Enable or Disable network policies for the private endpoint on the subnet.  
                                                      Possible values are Disabled, Enabled, NetworkSecurityGroupEnabled and RouteTableEnabled. Defaults to Disabled.

                                                      NOTE: If you don't want to use network policies like user-defined Routes and Network Security Groups, you need to set _private\_endpoint\_network\_policies_ in the subnet to Disabled.  
                                                      This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet.  
                                                      For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the _azurerm\_subnet\_network\_security\_group\_association_ resource.

                                                      NOTE: If you want to use network policies like user-defined Routes and Network Security Groups, you need to set the _private\_endpoint\_network\_policies_ in the Subnet to Enabled/NetworkSecurityGroupEnabled/RouteTableEnabled.  
                                                      This setting only applies to Private Endpoints in the Subnet and affects all Private Endpoints in the Subnet.  
                                                      For other resources in the Subnet, access is controlled based via the Network Security Group which can be configured using the __azurerm\_subnet\_network\_security\_group\_association__ resource.

                                                      For more details check: https://learn.microsoft.com/en-gb/azure/private-link/disable-private-endpoint-network-policy?tabs=network-policy-portal.

    `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to true.

                                                      NOTE: When configuring Azure Private Link service, the explicit setting _private\_link\_service\_network\_policies\_enabled_ must be set to false in the subnet since Private Link Service does not support network policies like user-defined Routes and Network Security Groups.  
                                                      This setting only affects the Private Link service. For other resources in the subnet, access is controlled based on the Network Security Group which can be configured using the _azurerm\_subnet\_network\_security\_group\_association_ resource.  
                                                      For more details check: https://learn.microsoft.com/en-gb/azure/private-link/disable-private-link-service-network-policy?tabs=private-link-network-policy-powershell.

    `service_endpoints`                             - (Optional) The list of Service endpoints to associate with the subnet. Possible values include:
                                                        - Microsoft.AzureActiveDirectory
                                                        - Microsoft.AzureCosmosDB
                                                        - Microsoft.ContainerRegistry
                                                        - Microsoft.EventHub, Microsoft.KeyVault
                                                        - Microsoft.ServiceBus
                                                        - Microsoft.Sql
                                                        - Microsoft.Storage
                                                        - Microsoft.Storage.Global
                                                        - Microsoft.Web

                                                      In order to use Microsoft.Storage.Global service endpoint (which allows access to virtual networks in other regions), you must enable the AllowGlobalTagsForStorage feature in your subscription.  
                                                      For more details check https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-cli#enabling-access-to-virtual-networks-in-other-regions-preview.

    `service_endpoint_policy_ids`                   - (Optional) A list of Service Endpoint Policy IDs to associate with the subnet.

    `delegation` - (Optional) A list of subnet delegation objects.

      `delegation_name` - (Required) A name for this delegation.

      `service_name`    - (Required) The name of service to delegate to. Possible values are:
                            - GitHub.Network/networkSettings
                            - Microsoft.ApiManagement/service
                            - Microsoft.Apollo/npu
                            - Microsoft.App/environments, Microsoft.App/testClients
                            - Microsoft.AVS/PrivateClouds
                            - Microsoft.AzureCosmosDB/clusters
                            - Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers
                            - Microsoft.Batch/batchAccounts
                            - Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, Microsoft.CloudTest/pools
                            - Microsoft.Codespaces/plans
                            - Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients
                            - Microsoft.Databricks/workspaces
                            - Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, Microsoft.DBforMySQL/serversv2
                            - Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers
                            - Microsoft.DelegatedNetwork/controller
                            - Microsoft.DevCenter/networkConnection
                            - Microsoft.DocumentDB/cassandraClusters
                            - Microsoft.Fidalgo/networkSettings-
                            - Microsoft.HardwareSecurityModules/dedicatedHSMs
                            - Microsoft.Kusto/clusters
                            - Microsoft.LabServices/labplans
                            - Microsoft.Logic/integrationServiceEnvironments
                            - Microsoft.MachineLearningServices/workspaces
                            - Microsoft.Netapp/volumes
                            - Microsoft.Network/dnsResolvers, Microsoft.Network/fpgaNetworkInterfaces, Microsoft.Network/networkWatchers, Microsoft.Network/virtualNetworkGateways
                            - Microsoft.Orbital/orbitalGateways
                            - Microsoft.PowerPlatform/enterprisePolicies, Microsoft.PowerPlatform/vnetaccesslinks
                            - Microsoft.ServiceFabricMesh/networks
                            - Microsoft.ServiceNetworking/trafficControllers
                            - Microsoft.Singularity/accounts/networks, Microsoft.Singularity/accounts/npu
                            - Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest
                            - Microsoft.StoragePool/diskPools
                            - Microsoft.StreamAnalytics/streamingJobs
                            - Microsoft.Synapse/workspaces
                            - Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms
                            - NGINX.NGINXPLUS/nginxDeployments
                            - PaloAltoNetworks.Cloudngfw/firewalls
                            - Qumulo.Storage/fileSystems

      `service_action`  - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values are:
                            - Microsoft.Network/networkinterfaces/*
                            - Microsoft.Network/publicIPAddresses/join/action
                            - Microsoft.Network/publicIPAddresses/read
                            - Microsoft.Network/virtualNetworks/read
                            - Microsoft.Network/virtualNetworks/subnets/action
                            - Microsoft.Network/virtualNetworks/subnets/join/action
                            - Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action
                            - Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action

Type:

```hcl
map(object({
    name                                          = string
    address_prefixes                              = set(string)
    default_outbound_access_enabled               = optional(bool, true)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(set(string))
    delegation = optional(map(object({
      delegation_name = optional(string)
      service_name    = optional(string)
      service_action  = optional(list(string))
    })))
  }))
```

Default: `null`

### <a name="input_vnet_deploy"></a> [vnet\_deploy](#input\_vnet\_deploy)

Description: (Optional) Required only when a new VNET is required to deploy.

Type: `bool`

Default: `false`

### <a name="input_vnet_dns_servers"></a> [vnet\_dns\_servers](#input\_vnet\_dns\_servers)

Description: (Optional) List of IP addresses of DNS servers for the new VNET.

Type: `set(string)`

Default: `null`

### <a name="input_vnet_edge_zone"></a> [vnet\_edge\_zone](#input\_vnet\_edge\_zone)

Description: (Optional) Specifies the Edge Zone within the Azure Region where this VNET should exist. Changing this forces a new resource to be created.

Type: `string`

Default: `null`

### <a name="input_vnet_encryption_state"></a> [vnet\_encryption\_state](#input\_vnet\_encryption\_state)

Description:     <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional)(Preview) Specifies if the encrypted VNET allows VM that does not support encryption. Possible values are DropUnencrypted and AllowUnencrypted.  
    For more information check https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-encryption-overview.

Type: `string`

Default: `null`

### <a name="input_vnet_flow_timeout_in_minutes"></a> [vnet\_flow\_timeout\_in\_minutes](#input\_vnet\_flow\_timeout\_in\_minutes)

Description: (Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes.

Type: `number`

Default: `null`

### <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name)

Description: (Optional) The name of the new VNET. Changing this forces a new resource to be created.

Type: `string`

Default: `null`

### <a name="input_vnet_object"></a> [vnet\_object](#input\_vnet\_object)

Description: (Optional) Required only when VNET is already existing.

Type: `any`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_additional_subnet_list"></a> [additional\_subnet\_list](#output\_additional\_subnet\_list)

Description: FOR TROUBLESHOOTING

### <a name="output_custom_subnet_list"></a> [custom\_subnet\_list](#output\_custom\_subnet\_list)

Description: FOR TROUBLESHOOTING

### <a name="output_default_subnet_list"></a> [default\_subnet\_list](#output\_default\_subnet\_list)

Description: FOR TROUBLESHOOTING

### <a name="output_subnet_list"></a> [subnet\_list](#output\_subnet\_list)

Description: Map of subnets with name and id of the existing or new VNET.

### <a name="output_vnet_guid"></a> [vnet\_guid](#output\_vnet\_guid)

Description: VNET GUID of the existing or new VNET.

### <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id)

Description: VNET ID of the existing or new VNET.

### <a name="output_vnet_releaser"></a> [vnet\_releaser](#output\_vnet\_releaser)

Description: The context user running the module deployment.

### <a name="output_vnet_subscription_id"></a> [vnet\_subscription\_id](#output\_vnet\_subscription\_id)

Description: Azure Subscription ID of the existing or new VNET.

### <a name="output_vnet_tenant_id"></a> [vnet\_tenant\_id](#output\_vnet\_tenant\_id)

Description: Azure Tenant ID of the existing or new VNET.

<!-- markdownlint-disable-file MD033 MD012 -->
## Contributing

* If you think you've found a bug in the code or you have a question regarding
  the usage of this module, please reach out to us by opening an issue in
  this GitHub repository.
* Contributions to this project are welcome: if you want to add a feature or a
  fix a bug, please do so by opening a Pull Request in this GitHub repository.
  In case of feature contribution, we kindly ask you to open an issue to
  discuss it beforehand.

## License

```text
MIT License

Copyright (c) 2024 LederWorks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
<!-- END_TF_DOCS -->