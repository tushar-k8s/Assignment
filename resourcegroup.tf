resource "azurerm_resource_group" "RG" {
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}
