################################ Resource Group
resource "azurerm_resource_group" "rgrp-tde3-ic-terratest-network-vnet" {
  name     = "rgrp-tde3-ic-terratest-network-vnet"
  location = "Germany West Central"
  tags     = local.tags
}
