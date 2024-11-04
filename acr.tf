resource "azurerm_container_registry" "vehicle" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "vehiclemsjava"
  sku                 = "Basic"
}

resource "azurerm_container_registry" "score" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "scoremsjava"
  sku                 = "Basic"
}