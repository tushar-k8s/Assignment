resource "azurerm_kubernetes_cluster" "aks_cluster" {
  dns_prefix          = var.dns_prefix
  name                = "${local.common_name}-k8scluster"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.RG.name}-nrg"

default_node_pool {
    name                 = element(var.agent_pool,0)
    vm_size              = element(var.agent_pool,1)
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    availability_zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
  }

service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

role_based_access_control {
    enabled = true
  }

network_profile {
    network_plugin    = element(var.network_profile, 0)
    load_balancer_sku = element(var.network_profile, 2)
    network_policy    = element(var.network_profile, 0)
  }

windows_profile {
    admin_username = var.windows_admin_username
    admin_password = var.windows_admin_password
  }

linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.azure_workspace.id
    }

kube_dashboard {
      enabled = true
    }
  }
  lifecycle {
    ignore_changes = [
      windows_profile,
      default_node_pool,
    ]
  }
  tags = var.tags
}
