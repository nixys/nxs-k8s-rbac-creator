terraform {
  required_version = ">= 1.0.0"

  required_providers {
    tls      = {}
    local    = {}
    template = {}
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.7.1"
    }
  }
}

provider "kubernetes" {
  host = var.k8s_api_endpoint

  insecure = var.k8s_insecure

  config_path    = var.k8s_config_path
  config_context = var.k8s_config_context
}
