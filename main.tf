resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "70.0.2"  # Ensure this matches a valid version
  namespace  = "monitoring"
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.10.4"  # Replace with a valid Grafana chart version
  namespace  = "monitoring"
}
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.port"
    value = "3000"
  }
}
output "grafana_url" {
  description = "The external IP address of the Grafana dashboard"
  value       = "http://${helm_release.grafana.name}.monitoring.svc.cluster.local:3000"
}
