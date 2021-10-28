resource "azurerm_kubernetes_cluster_node_pool" "windows" {
  availability_zones    = [1, 2, 3]
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  max_count             = 10
  min_count             = 3
  mode                  = "User"
  name                  = "Windows-Machine-nodepool"
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = 1024
  os_type               = "Windows" 
  vm_size               = "Standard_DS2_v2"
  priority              = "Spot"
  vnet_subnet_id        = azurerm_subnet.subnet.id
}
