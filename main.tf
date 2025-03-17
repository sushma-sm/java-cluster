resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  chart      = "prometheus-community/kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "70.0.2"  # Update this to the correct version
}

resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  chart      = "grafana/grafana"
  repository = "https://grafana.github.io/helm-charts"
  version    = "6.56.2"  # Update this to the correct version

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
