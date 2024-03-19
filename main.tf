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

resource "google_compute_network" "peering_network" {
  name                    = "peering-network"
  auto_create_subnetworks = false
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
  service_account {
    email  = google_service_account.service_account.email
    scopes = ["cloud-platform"]
  }
  network_interface {
    network    = google_compute_network.vpcnetwork.id
    subnetwork = google_compute_subnetwork.webapp.self_link
    access_config {
    }

  }

  tags = var.vm_tag

  metadata_startup_script = <<-EOT
sudo bash -c 'cat > /tmp/application.properties' <<EOF
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.url=jdbc:mysql://${google_sql_database_instance.instance.private_ip_address}/${var.DB_NAME}?createDatabaseIfNotExist=true&useUnicode=true&characterEncoding=utf8
spring.datasource.username=${var.DB_USER}
spring.datasource.password=${random_password.db_user_password.result}
spring.jpa.properties.hibernate.show_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.jpa.hibernate.ddl-auto=update
EOF
EOT

}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.vpcnetwork.self_link
}

resource "google_service_networking_connection" "private_services_connection" {
  network                 = google_compute_network.vpcnetwork.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

output "private_ip" {
  value = google_sql_database_instance.instance.private_ip_address
}


resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider            = google-beta
  project             = var.project_id
  name                = "private-instance-${random_id.db_name_suffix.hex}"
  database_version    = var.database_version
  region              = var.region
  depends_on          = [google_service_networking_connection.private_services_connection]
  deletion_protection = var.deletion_protection


  settings {
    tier    = var.database_tier
    edition = var.database_edition

    availability_type = var.availability_type
    disk_type         = var.disk_type
    disk_size         = var.disk_size

    ip_configuration {
      ipv4_enabled                                  = var.ipv4_enabled
      private_network                               = google_compute_network.vpcnetwork.id
      enable_private_path_for_google_cloud_services = true
    }

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }

  }
}

output "generated_instance_name" {
  value     = google_sql_database_instance.instance.name
  sensitive = true
}


resource "random_password" "db_user_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

output "generated_password" {
  value     = random_password.db_user_password.result
  sensitive = true
}

resource "google_sql_user" "database_user" {
  name     = var.DB_USER
  instance = google_sql_database_instance.instance.name
  password = random_password.db_user_password.result

}

resource "google_sql_database" "database" {
  name     = var.DB_NAME
  instance = google_sql_database_instance.instance.name
}


resource "google_compute_firewall" "allow_sql_access" {
  name    = "allow-sql-access"
  network = google_compute_network.vpcnetwork.self_link

  allow {
    protocol = "tcp"
    ports    = [3306]
  }

  source_tags = var.vm_tag
}

resource "google_compute_firewall" "allow_web_access_to_sql" {
  name    = "allow-web-access-to-sql"
  network = google_compute_network.vpcnetwork.self_link

  allow {
    protocol = "tcp"
    ports    = [3306]


  }
  source_tags = var.vm_tag
}

data "google_dns_managed_zone" "my_dns_zone" {
  name = var.DNS_NAME
}

resource "google_dns_record_set" "my_dns_record" {
  name         = data.google_dns_managed_zone.my_dns_zone.dns_name
  type         = var.DNS_Record
  ttl          = var.DNS_TTL
  managed_zone = data.google_dns_managed_zone.my_dns_zone.name
  rrdatas      = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]
}

resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
}

resource "google_service_account" "service_account" {
  account_id   = var.service_account_name
  display_name = var.service_account_display_name
}

resource "google_project_iam_binding" "logging_admin" {
  project = var.project_id
  role    = "roles/logging.admin"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

resource "google_project_iam_binding" "monitoring_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}