# GKE outputs

output "endpoint1" {
  value       = "${google_container_cluster.primary.endpoint}"
  description = "Endpoint for accessing the master node"
}
output "endpoint2" {
  value       = "${google_container_cluster.secondary.endpoint}"
  description = "Endpoint for accessing the master node"
}