terraform {
  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.4"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "kubernetes" {
  host        = "https://${aws_instance.cdo-03-instance.public_ip}:6443"
  token       = "cdo-03-super-secret-token"
  insecure    = true
  config_path = "${path.module}/dummy_kubeconfig"
}


provider "tls" {}
provider "random" {}
provider "local" {}
