resource "azurerm_container_registry" "acr" {
  name                = "pokemonlistacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "aks-acr-ra" {
  #principal_id               = azurerm_kubernetes_cluster.aks.service_principal[0].client_id
  #principal_id                     = data.azurerm_client_config.current.object_id
  #principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  principal_id = azurerm_kubernetes_cluster.aks.service_principal[0].client_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  #skip_service_principal_aad_check = true
}