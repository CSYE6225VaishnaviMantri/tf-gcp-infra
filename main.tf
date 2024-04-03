# terraform {
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "4.51.0"
#     }
#   }
# }

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "peering_network" {
  name                    = var.peering_network_name
  auto_create_subnetworks = var.peering_auto_create_subnetworks
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
  priority         = var.webapp_route_priority
  next_hop_gateway = var.nexthopgateway
}

resource "google_compute_firewall" "allow_webapplication_port" {
  name    = var.allow_webapplication_port_name
  network = google_compute_network.vpcnetwork.id
  allow {
    protocol = var.rule_ip_protocol
    ports    = [var.appport]
  }
  source_ranges = [google_compute_global_address.lb_ipv4_address.address]
  target_tags   = var.vm_tag
}

resource "google_compute_firewall" "deny_ssh_port" {
  name    = var.deny_ssh_port_name
  network = google_compute_network.vpcnetwork.id
  deny {
    protocol = var.rule_ip_protocol
    ports    = var.deny_ssh_ports
  }
  source_ranges = var.deny_ssh_source_ranges
  target_tags   = var.vm_tag
}

# resource "google_compute_instance" "vm_instance" {
#   name         = var.virtualmachinename
#   zone         = var.virtualmachinezone
#   machine_type = var.virtualmachinetype
#   boot_disk {
#     initialize_params {
#       image = var.virtualmachineimage
#       type  = var.virtualmachinedisktype
#       size  = var.virtualmachinedisksizegb
#     }
#   }
#   service_account {
#     email  = google_service_account.service_account.email
#     scopes = ["cloud-platform"]
#   }
#   network_interface {
#     network    = google_compute_network.vpcnetwork.id
#     subnetwork = google_compute_subnetwork.webapp.self_link
#     access_config {
#     }

#   }

#   tags = var.vm_tag

#   metadata_startup_script = <<-EOT
#   sudo bash -c 'cat > /tmp/application.properties' <<EOF
#   spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
#   spring.datasource.url=jdbc:mysql://${google_sql_database_instance.instance.private_ip_address}/${var.DB_NAME}?createDatabaseIfNotExist=true&useUnicode=true&characterEncoding=utf8
#   spring.datasource.username=${var.DB_USER}
#   spring.datasource.password=${random_password.db_user_password.result}
#   spring.jpa.properties.hibernate.show_sql=true
#   spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
#   spring.jpa.hibernate.ddl-auto=update
#   pubsub.projectId=${var.project_id}
#   pubsub.topicId=${google_pubsub_topic.pub_sub_topic.name}
#   EOF
#   EOT

# }

resource "google_compute_global_address" "private_ip_address" {
  name          = var.private_ip_address_name
  purpose       = var.private_ip_address_purpose
  address_type  = var.private_ip_address_type
  prefix_length = var.private_ip_prefix_length
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


data "google_dns_managed_zone" "existing_zone" {
  name = var.DNS_Zone_Name
}

resource "google_dns_record_set" "dns_record" {
  name         = var.DNS_NAME
  type         = var.DNS_Record
  ttl          = var.DNS_TTL
  managed_zone = data.google_dns_managed_zone.existing_zone.name
  rrdatas      = [google_compute_global_address.lb_ipv4_address.address]
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


resource "google_pubsub_topic" "pub_sub_topic" {
  name                       = var.pub_sub_name
  message_retention_duration = var.pubsubtopic_message_retention_duration
  depends_on                 = [google_service_networking_connection.private_services_connection]
}

# Create a Pub/Sub subscription
resource "google_pubsub_subscription" "pub_sub_subscription" {
  name                 = var.pubsub_subscription_name
  topic                = google_pubsub_topic.pub_sub_topic.name
  ack_deadline_seconds = var.ack_deadline_seconds
  expiration_policy {
    ttl = var.ttl
  }
}

resource "google_service_account" "function_service_account" {
  account_id   = var.cloudfunction_account_id
  display_name = var.cloudfunction_display_name
}

resource "google_project_iam_binding" "function_service_account_roles" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:${google_service_account.function_service_account.email}"
  ]
}

resource "google_storage_bucket" "function_code_bucket" {
  name     = var.cloudstorage_bucketname
  location = var.region
}

resource "google_storage_bucket_object" "function_code_objects" {
  name   = var.cloudstorage_bucketobjectname
  bucket = google_storage_bucket.function_code_bucket.name
  source = var.cloudstorage_source
}

resource "google_cloudfunctions2_function" "email_verification_function" {
  name     = var.cloudfunction_name
  location = var.region

  build_config {
    runtime     = var.cloudfunction_runtime
    entry_point = var.cloudfunction_entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.function_code_bucket.name
        object = google_storage_bucket_object.function_code_objects.name
      }
    }
  }

  service_config {
    max_instance_count            = var.max_instance_count
    min_instance_count            = var.min_instance_count
    available_memory              = var.available_memory
    timeout_seconds               = var.timeout_seconds
    vpc_connector                 = google_vpc_access_connector.connector.name
    vpc_connector_egress_settings = var.vpc_connector_egress_settings

    environment_variables = {
      SQL_HOST           = google_sql_database_instance.instance.private_ip_address
      SQL_USERNAME       = var.DB_USER
      SQL_PASSWORD       = random_password.db_user_password.result
      webappSQL_DATABASE = var.DB_NAME
    }

    ingress_settings               = var.ingress_settings
    all_traffic_on_latest_revision = var.all_traffic_on_latest_revision
    service_account_email          = google_service_account.function_service_account.email


  }
  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = google_pubsub_topic.pub_sub_topic.id
  }
}


resource "google_project_iam_binding" "pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

resource "google_project_iam_binding" "pubsub_service_account_roles" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:${google_service_account.service_account.email}"
  ]
}

resource "google_vpc_access_connector" "connector" {
  name          = var.vpc_connector_name
  region        = var.region
  ip_cidr_range = var.vpc_connector_ip_cidr_range
  network       = google_compute_network.vpcnetwork.name
}

resource "google_compute_region_instance_template" "webapp_regional_template" {
  name         = var.it_template_name
  description  = var.it_template_description
  machine_type = var.virtualmachinetype
  region       = var.region

  disk {
    source_image = var.virtualmachineimage
    disk_size_gb = var.virtualmachinedisksizegb
    disk_type    = var.virtualmachinedisktype
    auto_delete  = var.it_disk_auto_delete
    boot         = var.it_disk_boot
  }
  can_ip_forward = var.it_can_ip_forward

  network_interface {
    network    = google_compute_network.vpcnetwork.id
    subnetwork = google_compute_subnetwork.webapp.self_link
    access_config {
    }

  }

  tags = var.vm_tag

  metadata_startup_script = <<-EOT
  sudo bash -c 'cat > /tmp/application.properties' <<EOF
  spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
  spring.datasource.url=jdbc:mysql://${google_sql_database_instance.instance.private_ip_address}/${var.DB_NAME}?createDatabaseIfNotExist=true&useUnicode=true&characterEncoding=utf8
  spring.datasource.username=${var.DB_USER}
  spring.datasource.password=${random_password.db_user_password.result}
  spring.jpa.properties.hibernate.show_sql=true
  spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
  spring.jpa.hibernate.ddl-auto=update
  pubsub.projectId=${var.project_id}
  pubsub.topicId=${google_pubsub_topic.pub_sub_topic.name}
  EOF
  EOT

  # service_account {
  #   email  = google_service_account.service_account.email
  #   scopes = var.it_scopes
  # }
  service_account {
    email  = google_service_account.compute_service_account.email
    scopes = var.it_scopes
  }
  reservation_affinity {
    type = "NO_RESERVATION"
  }

}

resource "google_compute_health_check" "http_health_check" {
  name                = var.health_check_name
  check_interval_sec  = var.health_check_interval_sec
  timeout_sec         = var.health_check_timeout_sec
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  http_health_check {
    port         = var.appport
    request_path = var.health_check_request_path
  }
  log_config {
    enable = var.health_check_log_config_enable
  }

}

resource "google_compute_target_pool" "instance_target_pool" {
  name       = var.target_pools_name
  depends_on = [google_compute_health_check.http_health_check]
}

resource "google_compute_region_instance_group_manager" "webapp_igm" {
  name               = var.instance_group_manager_name
  base_instance_name = var.igm_base_instance_name
  region             = var.region

  version {
    instance_template = google_compute_region_instance_template.webapp_regional_template.self_link
  }
  target_pools = [google_compute_target_pool.instance_target_pool.self_link]
  target_size  = var.igm_target_size
  named_port {
    name = var.igm_named_port_name
    port = var.ignm_named_port_port
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.http_health_check.self_link
    initial_delay_sec = var.igm_auto_healing_initial_delay_sec
  }

  instance_lifecycle_policy {
    force_update_on_repair    = "YES"
    default_action_on_failure = "REPAIR"
  }
  depends_on = [
    google_compute_health_check.http_health_check,
    google_compute_region_instance_template.webapp_regional_template
  ]


}

resource "google_compute_region_autoscaler" "webapp_autoscaler" {
  name   = var.autoscaler_name
  region = var.region
  target = google_compute_region_instance_group_manager.webapp_igm.id

  autoscaling_policy {
    max_replicas    = var.autoscaler_max_replicas
    min_replicas    = var.autoscaler_min_replicas
    cooldown_period = var.autoscaler_cooldown_period

    cpu_utilization {
      target = var.autoscaler_target
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    google_compute_health_check.http_health_check,
    google_compute_region_instance_group_manager.webapp_igm,
    google_compute_target_pool.instance_target_pool
  ]
}



resource "google_compute_global_address" "lb_ipv4_address" {
  name = var.name_lb_ipv4_address
}

resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name                  = var.rule_name
  ip_protocol           = var.rule_ip_protocol
  load_balancing_scheme = var.rule_load_balancing_scheme
  ip_address            = google_compute_global_address.lb_ipv4_address.address
  port_range            = var.rule_port_range
  target                = google_compute_target_https_proxy.https_proxy.id
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name     = var.https_proxy_name
  provider = google
  url_map  = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.webapp_ssl_cert.name
  ]
  depends_on = [
    google_compute_managed_ssl_certificate.webapp_ssl_cert
  ]
}

resource "google_compute_url_map" "default" {
  name            = var.url_map_name
  provider        = google
  default_service = google_compute_backend_service.webapp_backend.id
}

resource "google_compute_managed_ssl_certificate" "webapp_ssl_cert" {
  name = var.ssl_certificate_name
  managed {
    domains = [var.DNS_NAME]
  }
}


resource "google_compute_backend_service" "webapp_backend" {
  name                            = var.webapp_backend_name
  protocol                        = var.webapp_backend_protocol
  port_name                       = var.webapp_backend_port_name
  health_checks                   = [google_compute_health_check.http_health_check.id]
  load_balancing_scheme           = var.webapp_backend_load_balancing_scheme
  timeout_sec                     = var.webapp_backend_timeout_sec
  enable_cdn                      = var.webapp_backend_enable_cdn
  connection_draining_timeout_sec = var.webapp_backend_connection_draining_timeout_sec
  # locality_lb_policy              = var.locality_lb_policy_name
  backend {
    group           = google_compute_region_instance_group_manager.webapp_igm.instance_group
    balancing_mode  = var.webapp_backend_balancing_mode
    capacity_scaler = var.webapp_backend_capacity_scaler
  }
  depends_on = [
    google_compute_region_instance_group_manager.webapp_igm
  ]

}

resource "google_compute_firewall" "allow_lb" {
  name    = var.allow_lb_name
  network = google_compute_network.vpcnetwork.id

  allow {
    protocol = var.allow_http_protocol
    ports    = var.allow_http_ports
  }

  source_ranges = var.allow_http_source_ranges
  source_tags   = var.vm_tag
}

resource "google_project_iam_binding" "instance_admin_binding" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]
}


resource "google_service_account" "vm_service_account" {
  account_id   = var.Autoscaler_service_account_name
  display_name = var.Autoscaler_service_account_display_name
}

resource "google_compute_firewall" "default" {
  name          = var.default_name
  provider      = google
  direction     = var.allow_http_direction
  network       = google_compute_network.vpcnetwork.id
  source_ranges = var.allow_http_source_ranges
  allow {
    protocol = var.allow_http_protocol
  }
  target_tags = ["allow-health-check"]
}

resource "google_service_account" "compute_service_account" {
  account_id   = var.compute_service_account_id
  display_name = var.compute_service_display_name
}

resource "google_project_iam_member" "compute_service_account_role" {
  project = var.project_id
  role    = "roles/compute.serviceAgent"
  member  = "serviceAccount:${google_service_account.compute_service_account.email}"
}

resource "google_compute_firewall" "allow_http" {
  name      = var.allow_http_name
  network   = google_compute_network.vpcnetwork.id
  direction = var.allow_http_direction
  allow {
    protocol = var.allow_http_protocol
    ports    = var.allow_http_ports
  }

  source_ranges = var.allow_http_source_ranges

  target_tags = ["http-server"]
}

resource "google_project_iam_binding" "invoker_binding" {
  members = ["serviceAccount:${google_service_account.function_service_account.email}"]
  project = var.project_id
  role    = "roles/run.invoker"
}
