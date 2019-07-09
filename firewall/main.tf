# VPC firewall configuration
# Create a firewall rule that allows internal communication across all protocols:
resource "google_compute_firewall" "firewalli-int" {
  name    = "${var.vpc_name}-firewall-int"
  network = "${var.vpc_name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }
   target_tags = ["firstcluster","secondcluster"] 
    source_ranges = ["${var.subnet_cidr1}","${var.subnet_cidr2}"]
}

# Create a firewall rule that allows external SSH, ICMP, and HTTPS:
resource "google_compute_firewall" "firewalli-ext" {
  name    = "${var.vpc_name}--firewall-ext"
   network = "${var.vpc_name}"
  // subnet   = "${var.subnet_cidr1}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "8443", "80", "443", "8080"]
  }
  target_tags = ["firstcluster"]
  source_ranges = ["0.0.0.0/0"]
}