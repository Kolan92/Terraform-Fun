output "kube_config" {
  value     = module.cluster.kube_config
  sensitive = true
}

output "cluster_ca_certificate" {
  value = module.cluster.cluster_ca_certificate
}

output "client_certificate" {
  value = module.cluster.client_certificate
}

output "client_key" {
  value = module.cluster.client_key
}

output "host" {
  value = module.cluster.host
}
