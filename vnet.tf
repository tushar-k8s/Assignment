resource "azurerm_virtual_network" "vnet" {
  address_space       = [element(var.address_space, 0)]
  location            = var.location
  name                = "${local.common_name}-vnet"
  resource_group_name = azurerm_resource_group.RG.name
}


resource "azurerm_subnet" "subnet" {
  address_prefix       = element(var.address_space, 1)
  name                 = "${local.common_name}-subnet"
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}
