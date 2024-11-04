# API Management
resource "azurerm_api_management" "main" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = local.apim_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = local.sku_name
}

resource "azurerm_api_management_api" "main" {
  resource_group_name   = azurerm_resource_group.rg.name
  api_management_name   = azurerm_api_management.main.name
  revision              = "1"
  name                  = "vehicle-api"
  display_name          = "Vehicle API"
  path                  = "vehicle"
  protocols             = ["https"]
  service_url           = "http://${data.kubernetes_service.service.status.0.load_balancer.0.ingress.0.ip}/api/v1/vehicle"
  subscription_required = false
}

resource "azurerm_api_management_backend" "main" {
  name                = "aks-backend"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.main.name
  protocol            = "http"
  url                 = "http://${data.kubernetes_service.service.status.0.load_balancer.0.ingress.0.ip}"

  tls {
    validate_certificate_chain = false
  }
}

resource "azurerm_api_management_api_operation" "vehicle_operation" {
  api_name            = azurerm_api_management_api.main.name
  api_management_name = azurerm_api_management_api.main.api_management_name
  resource_group_name = azurerm_api_management_api.main.resource_group_name
  operation_id        = "get-score"
  display_name        = "Get Score"
  method              = "GET"
  url_template        = "/{plate}"
  description         = "Placa del vehículo"

  template_parameter {
    name     = "plate"
    type     = "string"
    required = true
  }

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_policy" "cors_policy" {
  api_name            = azurerm_api_management_api.main.name
  api_management_name = azurerm_api_management_api.main.api_management_name
  resource_group_name = azurerm_api_management_api.main.resource_group_name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <cors allow-credentials="false">
            <allowed-origins>
                <origin>https://elegant-cassata-735cc3.netlify.app/</origin>
            </allowed-origins>
            <allowed-methods>
                <method>GET</method>
            </allowed-methods>
        </cors>
        <set-header name="cache-control" exists-action="append">
            <value>no-cache</value>
        </set-header>
        <set-header name="pragma" exists-action="override">
            <value>no-cache</value>
        </set-header>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

resource "azurerm_api_management_api_policy" "header_no_cache" {
  api_name            = azurerm_api_management_api.main.name
  api_management_name = azurerm_api_management_api.main.api_management_name
  resource_group_name = azurerm_api_management_api.main.resource_group_name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <cors allow-credentials="false">
            <allowed-origins>
                <origin>https://elegant-cassata-735cc3.netlify.app/</origin>
            </allowed-origins>
            <allowed-methods>
                <method>GET</method>
            </allowed-methods>
        </cors>
        <set-header name="cache-control" exists-action="append">
            <value>no-cache</value>
        </set-header>
        <set-header name="pragma" exists-action="override">
            <value>no-cache</value>
        </set-header>
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}
