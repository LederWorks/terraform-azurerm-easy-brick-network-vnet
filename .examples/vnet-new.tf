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