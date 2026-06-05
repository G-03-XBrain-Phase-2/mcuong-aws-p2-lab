resource "terraform_data" "wait_for_k3s" {
  depends_on = [aws_instance.cdo-03-instance]

  triggers_replace = aws_instance.cdo-03-instance.id

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for K3s API Server to be ready at https://${aws_instance.cdo-03-instance.public_ip}:6443 ..."
      until curl -k -s https://${aws_instance.cdo-03-instance.public_ip}:6443/ping | grep -q "pong"; do
        sleep 5
      done
      echo "K3s API Server port is open! Waiting 15 seconds for API groups to fully initialize..."
      sleep 15
      echo "K3s API Server is ready!"
    EOT
  }
}

resource "kubernetes_deployment_v1" "react_app" {
  depends_on = [terraform_data.wait_for_k3s]

  metadata {
    name      = "react-frontend"
    namespace = "default"
    labels = {
      app = "react-app"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "react-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "react-app"
        }
      }

      spec {
        container {
          name  = "react-frontend"
          image = var.react_image

          port {
            container_port = 80
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "250m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "react_service" {
  depends_on = [terraform_data.wait_for_k3s]

  metadata {
    name      = "react-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "react-app"
    }

    type = "NodePort"

    port {
      port        = 80
      target_port = 80
      node_port   = 30080
    }
  }
}
