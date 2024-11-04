# Obtener información del cluster AKS existente
data "azurerm_kubernetes_cluster" "existing" {
  name                = "vehicle-score-platform"
  resource_group_name = "rg-vehicle-platform"
}

# Crear un servicio de tipo LoadBalancer para exponer el pod
resource "kubernetes_service" "service" {
  metadata {
    name = "vehicle-ms-service"
  }

  spec {
    selector = {
      app = "vehicle-ms"  # Debe coincidir con las labels del pod
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

# Obtener la IP pública del servicio
data "kubernetes_service" "service" {
  metadata {
    name = kubernetes_service.service.metadata[0].name
  }

  depends_on = [kubernetes_service.service]
}

# Output para mostrar la IP pública
output "public_ip" {
  value = data.kubernetes_service.service.status.0.load_balancer.0.ingress.0.ip
}

# Provider configuration
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.existing.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.existing.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.existing.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.existing.kube_config.0.cluster_ca_certificate)
}