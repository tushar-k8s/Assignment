variable "location" {
  type = string
  description = "Location for Azure resources what will be created"
  default = "eastus"
}

variable "resource_group_name" {
  type = string
  description = "Resource group name"
  default = "terraform-aks"
}

locals {
  common_name = "Azure_K8S"
}


variable "address_space" {
  default = ["10.1.0.0/16", "10.1.0.0/24", "10.1.0.0/32"]
}

variable "dns_prefix" {
  default = "azurek8sdemo"
}


variable "agent_pool" {
  default = ["defaultpool","Standard_D2s_v3"]
}

variable "ssh_public_key" {
  default = "~/.ssh/test/test.pub"
    
}

variable "windows_admin_username" {
  type = string
  default = "windowuser"
    
}

variable "windows_admin_password" {
  type = string
  default = "Test@123"
    
}


variable "tags" {
  default = {
    terraform = "yes",
    resource  = "AKS",
    purpose   = "demo"
  }
}

variable "network_profile" {
  default = ["azure", "kubenet", "Standard"]
}

variable "publicip_sku" {
  default = ["Basic","Standard"]
}
