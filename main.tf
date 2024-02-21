terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpcnetwork" {
  name                            = var.vpcname
  auto_create_subnetworks         = var.autocreatesubnets
  routing_mode                    = var.routingmode
  delete_default_routes_on_create = var.deletedefaultroutes
}
resource "google_compute_subnetwork" "webapp" {
  name                     = var.websubnetname
  ip_cidr_range            = var.webappcidr
  network                  = google_compute_network.vpcnetwork.self_link
  private_ip_google_access = var.privateipgoogleaccess
}

resource "google_compute_subnetwork" "db" {
  name                     = var.dbsubnetname
  ip_cidr_range            = var.dbcidr
  network                  = google_compute_network.vpcnetwork.self_link
  private_ip_google_access = var.privateipgoogleaccess
}

resource "google_compute_route" "webapp_route" {
  name             = var.webapproutename
  network          = google_compute_network.vpcnetwork.name
  dest_range       = var.webapproutecidr
  priority         = 1000
  next_hop_gateway = var.nexthopgateway
}

resource "google_compute_firewall" "allow_webapplication_port" {
  name    = "${var.vpcname}-allow-webapplication"
  network = google_compute_network.vpcnetwork.id
  allow {
    protocol = "tcp"
    ports    = [var.appport]
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "deny_ssh_port" {
  name    = "${var.vpcname}-deny-ssh"
  network = google_compute_network.vpcnetwork.id
  deny {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_instance" "vm_instance" {
  name         = var.virtualmachinename
  zone         = var.virtualmachinezone
  machine_type = var.virtualmachinetype
  boot_disk {
    initialize_params {
      image = var.virtualmachineimage
      type  = var.virtualmachinedisktype
      size  = var.virtualmachinedisksizegb
    }
  }
  
  network_interface {
    network    = google_compute_network.vpcnetwork.id
    subnetwork = google_compute_subnetwork.webapp.self_link
    access_config {
    }
  }
}

