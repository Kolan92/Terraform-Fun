terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.48.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "simple-k8s-ResourceGroup"
  location = "westeurope"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "simple-k8s-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "simple-k8s-cluster"

  default_node_pool {
    name       = "default"
    node_count = "2"
    vm_size    = "standard_d2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.cluster.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}


locals {
  default_port    = 80
  app_name        = "hello-kubernetes"
  cluster_ip_name = "${local.app_name}-cluster-ip-service"
}

resource "kubernetes_ingress" "nginx_ingress" {
  metadata {
    name = "nginx-kubernetes"

    annotations = {
      "kubernetes.io/ingress.class" = "addon-http-application-routing"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/"

          backend {
            service_name = local.cluster_ip_name
            service_port = local.default_port
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "hello_kubernetes" {
  metadata {
    name = local.app_name
  }

  spec {
    selector {
      match_labels = {
        app = local.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.app_name
        }
      }

      spec {
        container {
          name  = "app"
          image = "hashicorp/http-echo"

          args = ["-listen=:${local.default_port}", "-text='Hello World'"]
          port {
            container_port = local.default_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello-kubernetes-cluster-ip-service" {
  metadata {
    name = local.cluster_ip_name
  }

  spec {
    port {
      name        = "http"
      protocol    = "TCP"
      port        = local.default_port
      target_port = local.default_port
    }

    selector = {
      app = local.app_name
    }

    type = "ClusterIP"
  }
}
