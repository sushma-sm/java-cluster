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
  values     = []
}

output "grafana_url" {
  value = "http://localhost:3000"
}
