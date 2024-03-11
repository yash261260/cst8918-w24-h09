provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks" {
  name     = "my-aks-resource-group"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
    enable_auto_scaling = true
    min_count = 1
    max_count = 3
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw

  sensitive = true
}
