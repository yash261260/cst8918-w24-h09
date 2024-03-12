terraform { 
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0" 
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "hybrid-h09-aks-rg" 
  location = "Canada Central" 
}

# Create an AKS Cluster
resource "azurerm_kubernetes_cluster" "app" {
  name                = "hybrid-h09-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "hybrid-h09-aks"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size             = "Standard_B2s"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.29.0"
}

# Output the kubeconfig
output "kube_config" {
  value     = azurerm_kubernetes_cluster.app.kube_config_raw
  sensitive = true
}
