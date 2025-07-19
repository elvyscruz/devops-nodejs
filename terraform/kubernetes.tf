resource "kubernetes_deployment" "app" {
  metadata {
    name = "my-app"
    labels = {
      app = "my-app"
    }
  }

  spec {
    replicas = 2  # Réplicas iniciales

    selector {
      match_labels = {
        app = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }

      spec {
        container {
          name  = "my-app"
          image = "elvyscruz/my-app:latest"  
          port {
            container_port = 80
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}

# Horizontal Pod Autoscaler (HPA)
resource "kubernetes_horizontal_pod_autoscaler" "app" {
  metadata {
    name = "my-app-hpa"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.app.metadata[0].name
    }

    min_replicas = 2    # Mínimo de réplicas
    max_replicas = 5    # Máximo de réplicas

    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50  
        }
      }
    }
  }
}

# Service (LoadBalancer AWS)
resource "kubernetes_service" "app" {
  metadata {
    name = "my-app-service"
  }

  spec {
    selector = {
      app = kubernetes_deployment.app.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"  
  }
}