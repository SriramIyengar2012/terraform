// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("${var.credentials}")}"
 project     = "${var.gcp_project}" 
 region      = "${var.region}"
}

//  Need to add beta provider block as istio is in beta

/* provider "google-beta" {
 credentials = "${file("${var.credentials}")}"
 project     = "${var.gcp_project}" 
 region      = "${var.region}"
} */


// VPC Module
module "vpc" {
  source = "./vpc"
  name   = "${var.name}-vpc"
}

//Subnet Module

module "subnet" {
  source      = "./subnet"
  region      = "${var.region}"
  vpc_name     = "${module.vpc.vpc_name}"
  subnet_cidr1 = "${var.subnet_cidr1}"
  subnet_cidr2 = "${var.subnet_cidr2}"
}

//firewall module

module "firewall" {
  source        = "./firewall"
  vpc_name       = "${module.vpc.vpc_name}"
  subnet_cidr1   = "${var.subnet_cidr1}"
  subnet_cidr2   = "${var.subnet_cidr2}"
}


# Enable Kubernetes Engine API for the project.
resource "google_project_service" "kubernetes" {
  project = "${var.gcp_project}"
  service = "container.googleapis.com"
}

# Manages a Google Kubernetes Engine (GKE) cluster.
resource "google_container_cluster" "primary" {

  provider = "google"
 // provider = "google-beta"

  name = "${var.cluster1}"
  location    = "${var.region}-b"
  network     = "${module.vpc.vpc_name}"
  subnetwork  = "${module.subnet.subnet_name1}"

  # Waits for Kubernetes Engine API to be enabled
  depends_on = ["google_project_service.kubernetes"]

  # Disable basic auth
  remove_default_node_pool = true
  initial_node_count = 2
  


 // addons_config {
  //istio_config {
    //  disabled = false
  //  }
 // }
//  ip_allocation_policy {
  
//      use_ip_aliases = true
     // cluster_secondary_range_name = "prim_range_pod"
     // services_secondary_range_name = "prim_range_serv"
 // }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}
resource "google_container_node_pool" "kubernetes_preemptible_nodes" {

    name       = "my-node-pool"
  location   = "${var.region}-b"
  cluster    = "${google_container_cluster.primary.name}"
  
   management { 
    auto_repair = "true"
    auto_upgrade = "true"
  }

  autoscaling { 
    min_node_count = "${var.general_purpose_min_node_count}"
    max_node_count = "${var.general_purpose_max_node_count}"
  }
  initial_node_count = "${var.general_purpose_min_node_count}"


  node_config {
    preemptible  = true
    machine_type = "${var.general_purpose_machine_type}"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  
  # Tags are used to identify valid sources or targets for network firewalls.
    tags = [
    "firstcluster",
    ] 

  }
}
   # Manages a Google Kubernetes Engine (GKE) cluster.
resource "google_container_cluster" "secondary" {

  //provider = "google"
  provider = "google-beta"


  name = "${var.cluster2}"
  location    = "${var.region}-b"
  network     = "${module.vpc.vpc_name}"
  //subnetwork  = "${google_compute_subnetwork.subnet2.name}"
  subnetwork  = "${module.subnet.subnet_name2}"

  # Waits for Kubernetes Engine API to be enabled
  depends_on = ["google_project_service.kubernetes"]

  # Disable basic auth
  remove_default_node_pool = true
  initial_node_count = 2
  
  //ip_allocation_policy {
    //  use_ip_aliases = true
      // cluster_secondary_range_name = "sec_range_pod"
      // services_secondary_range_name = "sec_range_serv"
  //}
  
  //addons_config {
  // istio_config {
    //  disabled = false
    //}
  //}
  
  
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}
resource "google_container_node_pool" "secondary_preemptible_nodes" {
  name       = "my-second-node-pool"
  location   = "${var.region}-b"
  cluster    = "${google_container_cluster.secondary.name}"
  

   management { 
    auto_repair = "true"
    auto_upgrade = "true"
  }

  autoscaling { 
    min_node_count = "${var.general_purpose_min_node_count}"
    max_node_count = "${var.general_purpose_max_node_count}"
  }
  initial_node_count = "${var.general_purpose_min_node_count}"


  node_config {
    preemptible  = true
    machine_type = "${var.general_purpose_machine_type}"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  
  # Tags are used to identify valid sources or targets for network firewalls.
     tags = [
    "secondcluster",
    ]


  }
}
