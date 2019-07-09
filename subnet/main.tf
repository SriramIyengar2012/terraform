
// Create Subnet
resource "google_compute_subnetwork" "subnet1" {
 name          = "${var.vpc_name}-subnet1"
 ip_cidr_range = "${var.subnet_cidr1}"
 network       = "${var.vpc_name}"
 region      = "${var.region}"
}
// Create Subnet
resource "google_compute_subnetwork" "subnet2" {
 name          = "${var.vpc_name}-subnet2"
 ip_cidr_range = "${var.subnet_cidr2}"
 network       = "${var.vpc_name}"
  region      = "${var.region}"
}
