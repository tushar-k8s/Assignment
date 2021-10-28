terraform {
  backend "azurerm" {
    resource_group_name  = "######"
    storage_account_name = "abcd1234"
    container_name       = "tfstate"
    key                  = "AKS.terraform.tfstate"
  }
}
