
resource "kubernetes_pod" "app" {
  metadata {
    name = "app"
    labels {
      app = "app1"
    }
  }

  spec {
    container {
      image = "${var.sourceimageapp}"
      name  = "appexp"

      port {
        container_port = 8300
      }
    }
  }
}
~  
