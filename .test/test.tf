################################ Module Test
module "azurerm-network-vnet" {
  source = "../"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.rgrp-tde3-ic-terratest-network-vnet

  #Tags
  tags = local.tags

  ### Global Variables ###

  vnet_deploy = true
  # vnet_object = "" # Needed for existing vnet
  vnet_name                         = "vnet-tde3-ic-network-vnet"
  vnet_address_space                = ["10.0.0.0/16", "172.20.0.0/26"]
  vnet_dns_servers                  = ["4.4.4.4", "8.8.8.8"]
  # vnet_edge_zone                    = ""
  # vnet_bgp                          = ""
  # vnet_ddos_protection_plan_enabled = true
  # vnet_ddos_protection_plan_id      = ""
  # vnet_encryption_state             = "AllowUnencrypted"


  ### Local Variables ###

  #########################
  #### Default Subnets ####
  #########################

  vnet_default_subnets = {

    bastion = {
      name                                          = "AzureBastionSubnet"
      address_prefixes                              = ["172.20.0.0/26"]
    }

    default1 = {
      name                                          = "snet-tde3-ic-default1"
      address_prefixes                              = ["10.0.0.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.KeyVault"]
      delegation = {
        nic = {
          delegation_name = "nic"
          service_name = "Microsoft.Web/serverFarms"
          # service_action = []
        }
      }
    }

    default2 = {
      name                                          = "snet-tde3-ic-default2"
      address_prefixes                              = ["10.0.1.0/24"]
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    }
  }


  ############################
  #### Additional Subnets ####
  ############################

  vnet_additional_subnets = {
    additional1 = {
      name                                          = "snet-tde3-ic-additional1"
      address_prefixes                              = ["10.0.10.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }

    additional2 = {
      name                                          = "snet-tde3-ic-additional2"
      address_prefixes                              = ["10.0.11.0/24"]
    }
  }


  ###########################
  #### Custom Subnets #######
  ###########################

  vnet_custom_subnets = {
    custom1 = {
      name                                          = "snet-tde3-ic-custom1"
      address_prefixes                              = ["10.0.20.0/24"]
      private_endpoint_network_policies_enabled     = true
    }

    custom2 = {
      name                                          = "snet-tde3-ic-custom2"
      address_prefixes                              = ["10.0.21.0/24"]
      private_link_service_network_policies_enabled = true
    }
  }


}
