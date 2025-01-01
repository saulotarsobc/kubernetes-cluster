terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.21"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kubernetes-admin@kubernetes"
}

# Criar o Namespace
resource "kubernetes_namespace" "hcode" {
  metadata {
    name = "hcode"
  }
}

# NGINX Deployment
resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.hcode.metadata[0].name
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# NGINX Service
resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.hcode.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

# MinIO Deployment
resource "kubernetes_deployment" "minio" {
  metadata {
    name      = "minio"
    namespace = kubernetes_namespace.hcode.metadata[0].name
    labels = {
      app = "minio"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "minio"
      }
    }

    template {
      metadata {
        labels = {
          app = "minio"
        }
      }

      spec {
        container {
          name  = "minio"
          image = "minio/minio:latest"
          args  = ["server", "/data"]
          env {
            name  = "MINIO_ACCESS_KEY"
            value = "minioadmin"
          }
          env {
            name  = "MINIO_SECRET_KEY"
            value = "minioadmin"
          }
          port {
            container_port = 9000
          }
          volume_mount {
            name       = "data"
            mount_path = "/data"
          }
        }

        volume {
          name = "data"
          empty_dir {}
        }
      }
    }
  }
}

# MinIO Service
resource "kubernetes_service" "minio" {
  metadata {
    name      = "minio-service"
    namespace = kubernetes_namespace.hcode.metadata[0].name
  }

  spec {
    selector = {
      app = "minio"
    }

    port {
      port        = 9000
      target_port = 9000
    }

    type = "NodePort"
  }
}
