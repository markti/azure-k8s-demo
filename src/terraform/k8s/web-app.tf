locals {
  web_app_name = "fleet-portal"
}

resource "kubernetes_deployment" "web_app" {
  metadata {
    name      = local.web_app_name
    namespace = var.namespace
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = local.web_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.web_app_name
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = local.web_app_name

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}