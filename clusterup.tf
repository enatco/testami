provider "google" {
  credentials = "${file("account.json")}"
  project     = "kubetest-199610"
  region      = "us-east1-b"
}


resource "google_container_node_pool" "testpool" {
  name       = "testpool"
  zone       = "us-east1-b"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"
    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]
  }

    management {
          auto_repair  = true
          auto_upgrade = true
        }
        autoscaling {
         min_node_count = 1
         max_node_count = 3
        }

}

resource "google_container_cluster" "primary" {
  name               = "testcluster"
  zone               = "us-east1-b"
  additional_zones = [
    "us-east1-c",
  ]
  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_pool {
    name = "default-pool"
  }


}



resource "kubernetes_service" "lbnginx" {
  metadata {
    name = "lbnginx"
  }
  spec {
    selector {
      app = "${kubernetes_pod.sernginx.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port = 443
      target_port = 443
    }

    type = "LoadBalancer"
  }
}



resource "kubernetes_pod" "sernginx" {
  metadata {
    name = "nginx1"
    labels {
      app = "nginx"
    }
  }

  spec {
    container {
      image = "${var.sourceimageweb}"
      name  = "nginxapp"

      port {
        container_port = 443
        container_port = 80
      }
    }
  }
}
