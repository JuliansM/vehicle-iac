# Service Bus
resource "azurerm_servicebus_namespace" "sb" {
  name                = "sb-vehicle-platform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard" # Cambiarlo a premium para manejar picos altos de concurrencia de mensajes, establecer la capacidad en la necesaria
  # capacity            = 0 # Ajustado para alto rendimiento

  identity {
    type = "SystemAssigned"
  }
}

# Service Bus Topics
resource "azurerm_servicebus_topic" "request_topic" {
  name                  = "request-topic"
  namespace_id          = azurerm_servicebus_namespace.sb.id
  partitioning_enabled  = true
  max_size_in_megabytes = 1024
}

resource "azurerm_servicebus_topic" "response_topic" {
  name                  = "response-topic"
  namespace_id          = azurerm_servicebus_namespace.sb.id
  partitioning_enabled  = true
  max_size_in_megabytes = 1024
}

# Service Bus Subscriptions
resource "azurerm_servicebus_subscription" "vehicle_subscription" {
  name               = "vehicle-subscription"
  topic_id           = azurerm_servicebus_topic.response_topic.id
  max_delivery_count = 10
}

resource "azurerm_servicebus_subscription" "score_subscription" {
  name               = "score-subscription"
  topic_id           = azurerm_servicebus_topic.request_topic.id
  max_delivery_count = 10
}
