# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.75.0" # Optional but recommended in production
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  #subscription_id = "######"
  #client_id       = "#######"
  #client_secret   = "######"
  #tenant_id       = "######"
}

}

resource "random_id" "azure_random" {
  byte_length = 8
}
