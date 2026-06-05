resource "terraform_data" "wait_for_k3s" {
  depends_on = [aws_instance.cdo-03-instance]

  triggers_replace = aws_instance.cdo-03-instance.id

  provisioner "local-exec" {
    command     = local.is_windows ? "[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }; Write-Host 'Waiting for K3s API Server to be ready at https://${aws_instance.cdo-03-instance.public_ip}:6443 ...'; for ($i=0; $i -lt 60; $i++) { try { $res = Invoke-WebRequest -Uri https://${aws_instance.cdo-03-instance.public_ip}:6443/ping -UseBasicParsing -TimeoutSec 2; if ($res.Content -eq 'pong') { Write-Host 'K3s API Server port is open! Waiting 15 seconds for API groups to fully initialize...'; Start-Sleep -Seconds 15; Write-Host 'K3s API Server is ready!'; exit 0 } } catch {} Start-Sleep -Seconds 5 }; Write-Host 'Timeout waiting for K3s'; exit 1" : "echo 'Waiting for K3s API Server to be ready at https://${aws_instance.cdo-03-instance.public_ip}:6443 ...'; until curl -k -s https://${aws_instance.cdo-03-instance.public_ip}:6443/ping | grep -q 'pong'; do sleep 5; done; echo 'K3s API Server port is open! Waiting 15 seconds for API groups to fully initialize...'; sleep 15; echo 'K3s API Server is ready!'"
    interpreter = local.is_windows ? ["powershell", "-Command"] : ["/bin/sh", "-c"]
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
