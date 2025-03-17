resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  chart      = "prometheus-community/prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  values     = []
}

resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  chart      = "grafana/grafana"
  repository = "https://grafana.github.io/helm-charts"
  
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.port"
    value = "3000"
  }

  values = []
}

resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      app = "grafana"
    }
  }

  spec {
    selector = {
      app = "grafana"
    }

    type = "LoadBalancer"

    port {
      port        = 3000
      target_port = 3000
      protocol    = "TCP"
    }
  }
}

output "grafana_url" {
  description = "The external IP address of the Grafana dashboard"
  value       = "http://${kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].ip}:3000"
}
