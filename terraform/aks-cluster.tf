resource "azurerm_kubernetes_cluster" "aks" {
  name                = "pokemon-list-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "dns-prefix"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_Ds2"
  }

  service_principal {
    client_id     = var.appid
    client_secret = var.password
  }
}