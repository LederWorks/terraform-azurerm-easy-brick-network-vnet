# Change Log

## v0.3.0 [current]
FEATURES:
- Module updated to be azurerm ~>4.0.0 compliant. For details check https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/4.0-upgrade-guide
- Added vnet_flow_timeout_in_minutes property to VNET
- Added default_outbound_access_enabled property to subnets
- Added service_endpoint_policy_ids property to subnets
- Set minimum azurerm provider version to [4.9.0](https://github.com/hashicorp/terraform-provider-azurerm/releases/tag/v4.9.0)

ENHANCEMENTS:
- Updated private_endpoint_network_policies_enabled to private_endpoint_network_policies
- Introduced the azurerm_virtual_network_dns_servers resource to set up VNET DNS servers
- Added tags for the VNET
- Added validations for VNET variables
- Updated feature registration documentation with terraform code
- Update year to 2024 on license

## v0.2.1
BUG FIXES:
- Updated document format
- Terradocs workflow moved to pull request

## v0.2.0
FEATURES:
- Initial version
- Set minimum azurerm provider version to [3.68.0](https://github.com/hashicorp/terraform-provider-azurerm/releases/tag/v3.68.0)

## v0.1.0
FEATURES:
- Repository Init
