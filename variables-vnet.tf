
################################ VNET Variables
variable "vnet_deploy" {
  description = "(Optional) Required only when a new VNET is required to deploy."
  type        = bool
  default     = false
}

################################ Existing VNET
variable "vnet_object" {
  description = "(Optional) Required only when VNET is already existing."
  type        = any
  default     = null
}

################################ New VNET
variable "vnet_name" {
  description = "(Optional) The name of the new VNET. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "vnet_address_space" {
  description = "(Optional) The address space that is used for the new VNET. You can supply more than one address space."
  type        = set(string)
  default     = null
}

variable "vnet_dns_servers" {
  description = "(Optional) List of IP addresses of DNS servers for the new VNET."
  type        = set(string)
  default     = null
}

variable "vnet_edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this VNET should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "vnet_bgp" {
  description = "(Optional) The BGP community attribute in format <as-number>:<community-value> for the new VNET."
  type        = string
  default     = null
}

variable "vnet_ddos_protection_plan_enabled" {
  description = "(Optional) Enable or Disable DDOS protection plan for the new VNET."
  type        = bool
  default     = false
}

variable "vnet_ddos_protection_plan_id" {
  description = "(Optional) DDoS Protection plan ID for the new VNET."
  type        = string
  default     = null
}

variable "vnet_encryption_state" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional)(Preview) Specifies if the encrypted VNET allows VM that does not support encryption. Possible values are DropUnencrypted and AllowUnencrypted.
    For more information check https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-encryption-overview.

  EOT
  type        = string
  default     = null

  validation {
    condition     = var.vnet_encryption_state == null || can(index([null, "DropUnencrypted", "AllowUnencrypted"], var.vnet_encryption_state))
    error_message = "Invalid value for vnet_encryption_state. Valid values are DropUnencrypted, or AllowUnencrypted."
  }

}

################################ Default Subnets
variable "vnet_default_subnets" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) Default Subnets to create.
    `name`                                          - (Required) The name of the subnet. Changing this forces a new resource to be created.

    `address_prefixes`                              - (Required) The address prefixes to use for the subnet.
    
    `private_endpoint_network_policies_enabled`     - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Defaults to true.
    
    `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to true.
    
    `service_endpoints`                             - (Optional) The list of Service endpoints to associate with the subnet. 
                                                      Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web.
                                                      
                                                      In order to use Microsoft.Storage.Global service endpoint (which allows access to virtual networks in other regions), you must enable the AllowGlobalTagsForStorage feature in your subscription.
                                                      For more info heck https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-cli#enabling-access-to-virtual-networks-in-other-regions-preview.

    `delegation` - (Optional) A list of subnet delegation objects.
      
      `delegation_name` - (Required) A name for this delegation. 
      
      `service_name`    - (Required) The name of service to delegate to.
                          Possible values are GitHub.Network/networkSettings, Microsoft.ApiManagement/service, Microsoft.Apollo/npu, Microsoft.App/environments, Microsoft.App/testClients, Microsoft.AVS/PrivateClouds, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers, Microsoft.Batch/batchAccounts, Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, Microsoft.CloudTest/pools, Microsoft.Codespaces/plans, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.DelegatedNetwork/controller, Microsoft.DevCenter/networkConnection, Microsoft.DocumentDB/cassandraClusters, Microsoft.Fidalgo/networkSettings, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.LabServices/labplans, Microsoft.Logic/integrationServiceEnvironments, Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/dnsResolvers, Microsoft.Network/fpgaNetworkInterfaces, Microsoft.Network/networkWatchers., Microsoft.Network/virtualNetworkGateways, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/enterprisePolicies, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.ServiceNetworking/trafficControllers, Microsoft.Singularity/accounts/networks, Microsoft.Singularity/accounts/npu, Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments, PaloAltoNetworks.Cloudngfw/firewalls, and Qumulo.Storage/fileSystems.
      
      `service_action`  - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to.
                          Possible values are Microsoft.Network/networkinterfaces/*, Microsoft.Network/publicIPAddresses/join/action, Microsoft.Network/publicIPAddresses/read, Microsoft.Network/virtualNetworks/read, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.

  EOT
  type = map(object({
    name                                          = string
    address_prefixes                              = list(string)
    private_endpoint_network_policies_enabled     = optional(bool, false)
    private_link_service_network_policies_enabled = optional(bool, false)
    service_endpoints                             = optional(list(string))
    delegation = optional(map(object({
      delegation_name = optional(string)
      service_name    = optional(string)
      service_action  = optional(list(string))
    })))
  }))
  default = null

  ################################ Validations
  # validation {
  #   condition = var.vnet_default_subnets == null || try(alltrue([
  #     for o in var.vnet_default_subnets : 
  #   ]))
    
  #   # can(
  #   #   index(
  #   #     [
  #   #       null,
  #   #       "Microsoft.AzureActiveDirectory",
  #   #       "Microsoft.AzureCosmosDB",
  #   #       "Microsoft.ContainerRegistry",
  #   #       "Microsoft.EventHub",
  #   #       "Microsoft.KeyVault",
  #   #       "Microsoft.ServiceBus",
  #   #       "Microsoft.Sql",
  #   #       "Microsoft.Storage",
  #   #       "Microsoft.Storage.Global",
  #   #       "Microsoft.Web"
  #   #     ],
  #   #     element(var.vnet_default_subnets.service_endpoints, 0)
  #   #   )
  #   # )

  #   error_message = "Invalid value for service_endpoints."
  # }

  # validation {
  #   condition     = can(index(["GitHub.Network/networkSettings", "Microsoft.ApiManagement/service", "Microsoft.Apollo/npu", "Microsoft.App/environments", "Microsoft.App/testClients", "Microsoft.AVS/PrivateClouds", "Microsoft.AzureCosmosDB/clusters", "Microsoft.BareMetal/AzureHostedService", "Microsoft.BareMetal/AzureHPC", "Microsoft.BareMetal/AzurePaymentHSM", "Microsoft.BareMetal/AzureVMware", "Microsoft.BareMetal/CrayServers", "Microsoft.BareMetal/MonitoringServers", "Microsoft.Batch/batchAccounts", "Microsoft.CloudTest/hostedpools", "Microsoft.CloudTest/images", "Microsoft.CloudTest/pools", "Microsoft.Codespaces/plans", "Microsoft.ContainerInstance/containerGroups", "Microsoft.ContainerService/managedClusters", "Microsoft.ContainerService/TestClients", "Microsoft.Databricks/workspaces", "Microsoft.DBforMySQL/flexibleServers", "Microsoft.DBforMySQL/servers", "Microsoft.DBforMySQL/serversv2", "Microsoft.DBforPostgreSQL/flexibleServers", "Microsoft.DBforPostgreSQL/serversv2", "Microsoft.DBforPostgreSQL/singleServers", "Microsoft.DelegatedNetwork/controller", "Microsoft.DevCenter/networkConnection", "Microsoft.DocumentDB/cassandraClusters", "Microsoft.Fidalgo/networkSettings", "Microsoft.HardwareSecurityModules/dedicatedHSMs", "Microsoft.Kusto/clusters", "Microsoft.LabServices/labplans", "Microsoft.Logic/integrationServiceEnvironments", "Microsoft.MachineLearningServices/workspaces", "Microsoft.Netapp/volumes", "Microsoft.Network/dnsResolvers", "Microsoft.Network/fpgaNetworkInterfaces", "Microsoft.Network/networkWatchers", "Microsoft.Network/virtualNetworkGateways", "Microsoft.Orbital/orbitalGateways", "Microsoft.PowerPlatform/enterprisePolicies", "Microsoft.PowerPlatform/vnetaccesslinks", "Microsoft.ServiceFabricMesh/networks", "Microsoft.ServiceNetworking/trafficControllers", "Microsoft.Singularity/accounts/networks", "Microsoft.Singularity/accounts/npu", "Microsoft.Sql/managedInstances", "Microsoft.Sql/managedInstancesOnebox", "Microsoft.Sql/managedInstancesStage", "Microsoft.Sql/managedInstancesTest", "Microsoft.StoragePool/diskPools", "Microsoft.StreamAnalytics/streamingJobs", "Microsoft.Synapse/workspaces", "Microsoft.Web/hostingEnvironments", "Microsoft.Web/serverFarms", "NGINX.NGINXPLUS/nginxDeployments", "PaloAltoNetworks.Cloudngfw/firewalls", "Qumulo.Storage/fileSystems"], element(self.delegation[0].service_name, 0)))
  #   error_message = "Invalid value for service_name."
  # }

  # validation {
  #   condition     = can(alltrue([for action in self.delegation[0].service_action : can(index(["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/publicIPAddresses/join/action", "Microsoft.Network/publicIPAddresses/read", "Microsoft.Network/virtualNetworks/read", "Microsoft.Network/virtualNetworks/subnets/action", "Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"], action))]))
  #   error_message = "Invalid value for service_action."
  # }

}

################################ Additional Subnets
variable "vnet_additional_subnets" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) Additional Subnets to create.
    `name`                                          - (Required) The name of the subnet. Changing this forces a new resource to be created.

    `address_prefixes`                              - (Required) The address prefixes to use for the subnet.
    
    `private_endpoint_network_policies_enabled`     - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Defaults to true.
    
    `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to true.
    
    `service_endpoints`                             - (Optional) The list of Service endpoints to associate with the subnet. 
                                                      Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web.
                                                      
                                                      In order to use Microsoft.Storage.Global service endpoint (which allows access to virtual networks in other regions), you must enable the AllowGlobalTagsForStorage feature in your subscription.
                                                      For more info heck https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-cli#enabling-access-to-virtual-networks-in-other-regions-preview.

    `delegation` - (Optional) A map of subnet delegation objects.
      
      `delegation_name` - (Required) A name for this delegation. 
      
      `service_name`    - (Required) The name of service to delegate to.
                          Possible values are GitHub.Network/networkSettings, Microsoft.ApiManagement/service, Microsoft.Apollo/npu, Microsoft.App/environments, Microsoft.App/testClients, Microsoft.AVS/PrivateClouds, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers, Microsoft.Batch/batchAccounts, Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, Microsoft.CloudTest/pools, Microsoft.Codespaces/plans, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.DelegatedNetwork/controller, Microsoft.DevCenter/networkConnection, Microsoft.DocumentDB/cassandraClusters, Microsoft.Fidalgo/networkSettings, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.LabServices/labplans, Microsoft.Logic/integrationServiceEnvironments, Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/dnsResolvers, Microsoft.Network/fpgaNetworkInterfaces, Microsoft.Network/networkWatchers., Microsoft.Network/virtualNetworkGateways, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/enterprisePolicies, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.ServiceNetworking/trafficControllers, Microsoft.Singularity/accounts/networks, Microsoft.Singularity/accounts/npu, Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments, PaloAltoNetworks.Cloudngfw/firewalls, and Qumulo.Storage/fileSystems.
      
      `service_action`  - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to.
                          Possible values are Microsoft.Network/networkinterfaces/*, Microsoft.Network/publicIPAddresses/join/action, Microsoft.Network/publicIPAddresses/read, Microsoft.Network/virtualNetworks/read, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.

  EOT
  type = map(object({
    name                                          = string
    address_prefixes                              = list(string)
    private_endpoint_network_policies_enabled     = optional(bool)
    private_link_service_network_policies_enabled = optional(bool)
    service_endpoints                             = optional(list(string))
    delegation = optional(map(object({
      delegation_name = optional(string)
      service_name    = optional(string)
      service_action  = optional(list(string))
    })))
  }))
  default = null
}

################################ Custom Subnets
variable "vnet_custom_subnets" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Optional) Custom Subnets to create.
    `name`                                          - (Required) The name of the subnet. Changing this forces a new resource to be created.

    `address_prefixes`                              - (Required) The address prefixes to use for the subnet.
    
    `private_endpoint_network_policies_enabled`     - (Optional) Enable or Disable network policies for the private endpoint on the subnet. Defaults to true.
    
    `private_link_service_network_policies_enabled` - (Optional) Enable or Disable network policies for the private link service on the subnet. Defaults to true.
    
    `service_endpoints`                             - (Optional) The list of Service endpoints to associate with the subnet. 
                                                      Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web.
                                                      
                                                      In order to use Microsoft.Storage.Global service endpoint (which allows access to virtual networks in other regions), you must enable the AllowGlobalTagsForStorage feature in your subscription.
                                                      For more info heck https://learn.microsoft.com/en-us/azure/storage/common/storage-network-security?tabs=azure-cli#enabling-access-to-virtual-networks-in-other-regions-preview.

    `delegation` - (Optional) A list of subnet delegation objects.
      
      `delegation_name` - (Required) A name for this delegation. 
      
      `service_name`    - (Required) The name of service to delegate to.
                          Possible values are GitHub.Network/networkSettings, Microsoft.ApiManagement/service, Microsoft.Apollo/npu, Microsoft.App/environments, Microsoft.App/testClients, Microsoft.AVS/PrivateClouds, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureHostedService, Microsoft.BareMetal/AzureHPC, Microsoft.BareMetal/AzurePaymentHSM, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.BareMetal/MonitoringServers, Microsoft.Batch/batchAccounts, Microsoft.CloudTest/hostedpools, Microsoft.CloudTest/images, Microsoft.CloudTest/pools, Microsoft.Codespaces/plans, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.ContainerService/TestClients, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/servers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.DelegatedNetwork/controller, Microsoft.DevCenter/networkConnection, Microsoft.DocumentDB/cassandraClusters, Microsoft.Fidalgo/networkSettings, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.LabServices/labplans, Microsoft.Logic/integrationServiceEnvironments, Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/dnsResolvers, Microsoft.Network/fpgaNetworkInterfaces, Microsoft.Network/networkWatchers., Microsoft.Network/virtualNetworkGateways, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/enterprisePolicies, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.ServiceNetworking/trafficControllers, Microsoft.Singularity/accounts/networks, Microsoft.Singularity/accounts/npu, Microsoft.Sql/managedInstances, Microsoft.Sql/managedInstancesOnebox, Microsoft.Sql/managedInstancesStage, Microsoft.Sql/managedInstancesTest, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments, PaloAltoNetworks.Cloudngfw/firewalls, and Qumulo.Storage/fileSystems.
      
      `service_action`  - (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to.
                          Possible values are Microsoft.Network/networkinterfaces/*, Microsoft.Network/publicIPAddresses/join/action, Microsoft.Network/publicIPAddresses/read, Microsoft.Network/virtualNetworks/read, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.

  EOT
  type = map(object({
    name                                          = string
    address_prefixes                              = list(string)
    private_endpoint_network_policies_enabled     = optional(bool, true)
    private_link_service_network_policies_enabled = optional(bool, true)
    service_endpoints                             = optional(list(string))
    delegation = optional(map(object({
      delegation_name = optional(string)
      service_name    = optional(string)
      service_action  = optional(list(string))
    })))
  }))
  default = null
}
