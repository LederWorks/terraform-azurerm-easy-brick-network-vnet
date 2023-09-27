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