resource "azurerm_log_analytics_workspace" "azure_workspace" {
  location            = azurerm_resource_group.RG.location
  name                = "k8s-workspace-${random_id.azure_random.hex}"
  resource_group_name = azurerm_resource_group.RG.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_solution" "azure_logsolution" {
  location              = azurerm_resource_group.RG.location
  resource_group_name   = azurerm_resource_group.RG.name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.azure_workspace.name
  workspace_resource_id = azurerm_log_analytics_workspace.azure_workspace.id
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}


resource "azurerm_eventhub_namespace" "logging" {
  name                = "logging-eventhub"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  sku                 = "Standard"
  capacity            = 1
  kafka_enabled       = false
}


resource "azurerm_eventhub" "logging_aks" {
  name                = "logging-aks-eventhub"
  namespace_name      = azurerm_eventhub_namespace.logging.name
  resource_group_name = azurerm_resource_group.RG.name
  partition_count     = 2
  message_retention   = 1
}


resource "azurerm_eventhub_namespace_authorization_rule" "logging-rule" {
  name                = "authorization_rule"
  namespace_name      = azurerm_eventhub_namespace.logging.name
  resource_group_name = azurerm_resource_group.RG.name
  

  listen = true
  send   = true
  manage = true
}



resource "azurerm_monitor_diagnostic_setting" "aks-logging" {
  name                           = "diagnostic_aksl"
  target_resource_id             = azurerm_kubernetes_cluster.aks_cluster.id
  eventhub_name                  = azurerm_eventhub.logging_aks.name
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.logging-rule.id
  #log_analytics_workspace_id     = azurerm_log_analytics_workspace.azure_workspace.id

  log {
    category = "kube-scheduler"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-controller-manager"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "cluster-autoscaler"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-apiserver"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}
