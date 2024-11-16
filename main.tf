################################ VNET
resource "azurerm_virtual_network" "vnet" {
  for_each = var.vnet_deploy ? toset(["deploy"]) : toset([])

  name                    = var.vnet_name
  location                = var.resource_group_object.location
  resource_group_name     = var.resource_group_object.name
  address_space           = var.vnet_address_space
  bgp_community           = var.vnet_bgp
  edge_zone               = var.vnet_edge_zone
  flow_timeout_in_minutes = var.vnet_flow_timeout_in_minutes
  tags                    = local.tags

  dynamic "ddos_protection_plan" {
    for_each = var.vnet_ddos_protection_plan_id != null ? [1] : []

    content {
      enable = var.vnet_ddos_protection_plan_enabled
      id     = var.vnet_ddos_protection_plan_id
    }
  }

  dynamic "encryption" {
    for_each = var.vnet_encryption_state != null ? [1] : []

    content {
      enforcement = var.vnet_encryption_state
    }
  }
}

resource "azurerm_virtual_network_dns_servers" "vnet" {
  for_each = var.vnet_deploy ? toset(["deploy"]) : toset([])

  virtual_network_id = try(var.vnet_object.id, resource.azurerm_virtual_network.vnet["deploy"].id)
  dns_servers        = var.vnet_dns_servers
}

################################ Default Subnets
resource "azurerm_subnet" "default_subnet" {
  for_each = var.vnet_default_subnets != null ? var.vnet_default_subnets : {}

  name                                          = each.value.name
  resource_group_name                           = var.resource_group_object.name
  virtual_network_name                          = try(var.vnet_object.name, resource.azurerm_virtual_network.vnet["deploy"].name)
  address_prefixes                              = each.value.address_prefixes
  default_outbound_access_enabled               = each.value.default_outbound_access_enabled
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = coalesce(each.value.private_link_service_network_policies_enabled, true)
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids

  dynamic "delegation" {
    for_each = each.value.delegation != null ? each.value.delegation : {}

    content {
      name = delegation.value.delegation_name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.service_action
      }
    }
  }
}

################################ Additional Subnets
resource "azurerm_subnet" "additional_subnet" {
  for_each = var.vnet_additional_subnets != null ? var.vnet_additional_subnets : {}

  name                                          = each.value.name
  resource_group_name                           = var.resource_group_object.name
  virtual_network_name                          = try(var.vnet_object.name, resource.azurerm_virtual_network.vnet["deploy"].name)
  address_prefixes                              = each.value.address_prefixes
  default_outbound_access_enabled               = each.value.default_outbound_access_enabled
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = coalesce(each.value.private_link_service_network_policies_enabled, true)
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids

  dynamic "delegation" {
    for_each = each.value.delegation != null ? each.value.delegation : {}

    content {
      name = delegation.value.delegation_name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.service_action
      }
    }
  }
}

################################ Custom Subnets
resource "azurerm_subnet" "custom_subnet" {
  for_each = var.vnet_custom_subnets != null ? var.vnet_custom_subnets : {}

  name                                          = each.value.name
  resource_group_name                           = var.resource_group_object.name
  virtual_network_name                          = try(var.vnet_object.name, resource.azurerm_virtual_network.vnet["deploy"].name)
  address_prefixes                              = each.value.address_prefixes
  default_outbound_access_enabled               = each.value.default_outbound_access_enabled
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = coalesce(each.value.private_link_service_network_policies_enabled, true)
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids

  dynamic "delegation" {
    for_each = each.value.delegation != null ? each.value.delegation : {}

    content {
      name = delegation.value.delegation_name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.service_action
      }
    }
  }
}