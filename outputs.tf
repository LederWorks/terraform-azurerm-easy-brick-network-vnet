################################ Outputs
################################ auth
output "vnet_tenant_id" {
  value       = data.azurerm_client_config.current.tenant_id
  description = "Azure Tenant ID of the existing or new VNET."
}

output "vnet_subscription_id" {
  value       = data.azurerm_client_config.current.subscription_id
  description = "Azure Subscription ID of the existing or new VNET."
}

output "vnet_releaser" {
  value       = data.azurerm_client_config.current.client_id
  description = "The context user running the module deployment."
}

################################ VNET
output "vnet_id" {
  value       = var.vnet_object != null ? var.vnet_object.id : azurerm_virtual_network.vnet["deploy"].id
  description = "VNET ID of the existing or new VNET."
}

output "vnet_guid" {
  value       = var.vnet_object != null ? var.vnet_object.id : azurerm_virtual_network.vnet["deploy"].id
  description = "VNET GUID of the existing or new VNET."
}

output "subnet_list" {
  value       = local.subnet_list
  description = "Map of subnets with name and id of the existing or new VNET."
}

output "default_subnet_list" {
  value       = local.default_subnet_list
  description = "FOR TROUBLESHOOTING"
}

output "additional_subnet_list" {
  value       = local.additional_subnet_list
  description = "FOR TROUBLESHOOTING"
}

output "custom_subnet_list" {
  value       = local.custom_subnet_list
  description = "FOR TROUBLESHOOTING"
}
