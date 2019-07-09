# network subnet output

output "ip_cidr_range1" {
  value       = "${google_compute_subnetwork.subnet1.ip_cidr_range}"
  description = "Export created CICDR range"
}

output "subnet_name1" {
  value       = "${google_compute_subnetwork.subnet1.name}"
  description = "Export created CICDR range"
}
output "ip_cidr_range2" {
  value       = "${google_compute_subnetwork.subnet2.ip_cidr_range}"
  description = "Export created CICDR range"
}

output "subnet_name2" {
  value       = "${google_compute_subnetwork.subnet2.name}"
  description = "Export created CICDR range"
}