locals {
  ################################ Tags
  tags = merge(
    var.tags,
    {
      creation_mode                                  = "terraform"
      terraform-provider-easy-brick-category-purpose = "vX.X.X"
    }
  )

  ################################ Subnet Lists
  default_subnet_list = {
    for o in azurerm_subnet.default_subnet :
    o.name => {
      name : o.name,
      id : o.id
    }
  }

  additional_subnet_list = {
    for o in azurerm_subnet.additional_subnet :
    o.name => {
      name : o.name,
      id : o.id
    }
  }

  custom_subnet_list = {
    for o in azurerm_subnet.custom_subnet :
    o.name => {
      name : o.name,
      id : o.id
    }
  }

  subnet_list = merge(local.default_subnet_list, local.additional_subnet_list, local.custom_subnet_list)

}