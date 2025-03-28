resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "18.0.13"  # Latest available version from the provided list
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
}

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.10.4"  # Ensure this is a valid Grafana chart version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.port"
    value = "3000"
  }
}

output "instance_ip" {
  description = "Public IP address of the monitoring VM"
  value       = google_compute_instance.monitoring_vm.network_interface[0].access_config[0].nat_ip
}

