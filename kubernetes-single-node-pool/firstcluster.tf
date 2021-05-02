resource "digitalocean_kubernetes_cluster" "first_cluster" {
  name    = "first-cluster"
  region  = "ams3"
  version = "1.20.2-do.0"

  tags = ["kubernetes"]

  # This default node pool is mandatory
  node_pool {
    name       = "default-pool"
    size       = "s-1vcpu-2gb"
  auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
    tags       = ["node-pool"]
  }
}