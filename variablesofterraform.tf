
variable "project_id" {
  description = "Project ID"
  type        = string
}
variable "region" {
  description = "GCP Region"
  type        = string
}
variable "zone" {
  description = "GCP Zone"
  type        = string
}
variable "vpcname" {
  description = "VPC Name"
  type        = string
}
variable "websubnetname" {
  description = "Webapp subnet name"
  type        = string
}
variable "dbsubnetname" {
  description = "Db subnet name"
  type        = string
}
variable "webapproutename" {
  description = "Route of webapp"
  type        = string
}
variable "webappcidr" {
  description = "CIDR for webapp"
  type        = string
}
variable "dbcidr" {
  description = "CIDR for db"
  type        = string
}
variable "webapproutecidr" {
  description = "CIDR for webapp route"
  type        = string
}
variable "autocreatesubnets" {
  description = "Setting value to true or false to creating subnets by default"
  type        = bool
}
variable "deletedefaultroutes" {
  description = "Setting value to true or false to delete default routes"
  type        = bool
}
variable "routingmode" {
  description = "Setting routing mode"
  type        = string
}
variable "privateipgoogleaccess" {
  description = "Setting private ip google access of subnets"
  type        = bool
}
variable "nexthopgateway" {
  description = "Setting next hop gateway"
  type        = string
}
variable "appport" {
  description = "Application Port for allowing the firewall rules"
  type        = string
}
variable "virtualmachinename" {
  description = "Instance name that is being created"
  type        = string
}
variable "virtualmachinezone" {
  description = "Time Zone of the Virtual Machine"
  type        = string
}
variable "virtualmachinetype" {
  description = "Virtual Machine type of the instance being created"
  type        = string
}
variable "virtualmachineimage" {
  description = "Virtual machine boot disk image"
  type        = string
}
variable "virtualmachinedisktype" {
  description = "Virtual Machine boot disk type"
  type        = string
}
variable "virtualmachinedisksizegb" {
  description = "Boot disk size present in the VM in GB"
  type        = number
}

variable "availability_type" {
  description = "Availability type for the Cloud SQL instance"
  type        = string
}


variable "disk_type" {
  description = "Disk type for the Cloud SQL instance"
  type        = string
}

variable "disk_size" {
  description = "Disk size for the Cloud SQL instance (in GB)"
  type        = number
}

variable "ipv4_enabled" {
  description = "Whether to enable IPv4 for the Cloud SQL instance."
  type        = bool
}

variable "deletion_protection" {
  description = "Enable or disable deletion protection for a resource"
  type        = bool
}

variable "database_version" {
  description = "The version of the database to be used (e.g., MYSQL_5_7)"
  type        = string

}

variable "database_tier" {
  description = "The tier of the database instance (e.g., db-perf-optimized-N-2)"
  type        = string
}

variable "database_edition" {
  description = "The edition of the database instance (e.g., ENTERPRISE_PLUS)"
  type        = string
}

variable "vm_tag" {
  description = "Tags to apply to Compute Engine instances"
  type        = list(string)
}

variable "DB_USER" {
  description = "Name of the database user"
  type        = string
}

variable "DB_NAME" {
  description = "Name of the database"
  type        = string
}

variable "DNS_NAME" {
  description = "Name of the Domain"
  type        = string
}

variable "DNS_Record" {
  description = "Name of the DNS Record"
  type        = string
}

variable "DNS_TTL" {
  description = "Time to live"
  type        = number
}

variable "service_account_name" {
  description = "Name of the Service Account"
  type        = string
}

variable "service_account_display_name" {
  description = "Display Name of the Service Account"
  type        = string
}

variable "pub_sub_name" {
  description = "The name of the Google Cloud Pub/Sub topic"
  type        = string
}

variable "pubsubtopic_message_retention_duration" {
  description = "Pub/Sub Message Retention Duration"
  type        = string
}

variable "pubsub_subscription_name" {
  description = "Pub/Sub Subscription Name"
  type        = string
}

variable "ack_deadline_seconds" {
  description = "Ack Deadline Seconds"
  type        = number
}
variable "ttl" {
  description = "Pub/Sub TTL"
  type        = string
}
variable "cloudfunction_account_id" {
  description = "The account id of Cloud Function"
  type        = string
}
variable "cloudfunction_display_name" {
  description = "The display Name of Cloud Function"
  type        = string
}
variable "cloudstorage_bucketname" {
  description = "Cloud Storage Bucket Name"
  type        = string
}

variable "cloudstorage_bucketobjectname" {
  description = "Name of cloud storage bucket object"
  type        = string
}
variable "cloudstorage_source" {
  description = "Zip folder Source Name of cloud storage"
  type        = string
}

variable "cloudfunction_name" {
  description = "Name of the cloud function"
  type        = string
}
variable "cloudfunction_runtime" {
  description = "Cloud Function Runtime"
  type        = string
}
variable "cloudfunction_entry_point" {
  description = "Cloud Function Entry point"
  type        = string
}

variable "cloudfunction_available_memory_mb" {
  description = "Cloud Function Available memory"
  type        = number
}

variable "max_instance_count" {
  description = "Maximum number of instances to create for the Cloud Function"
  type        = number
}

variable "min_instance_count" {
  description = "Minimum number of instances to keep running for the Cloud Function"
  type        = number
}

variable "available_memory" {
  description = "Amount of memory available to the Cloud Function instances"
  type        = string
}

variable "timeout_seconds" {
  description = "Timeout duration in seconds for the Cloud Function execution"
  type        = number
}


variable "vpc_connector_egress_settings" {
  description = "Egress settings for the VPC connector"
  type        = string
}

variable "ingress_settings" {
  description = "Ingress settings for the Cloud Function"
  type        = string
}

variable "all_traffic_on_latest_revision" {
  description = "Set to true to route all traffic to the latest Cloud Function revision"
  type        = bool
}

variable "backend_service_name" {
  description = "Name of the backend service"
  default     = "backend-service"
}


variable "instance_group_name" {
  description = "Name of the instance group"
  default     = "instance-group-name"
}

variable "min_instances" {
  description = "Minimum number of instances in the autoscaler"
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of instances in the autoscaler"
  default     = 10
}



variable "DNS_Zone_Name" {
  type        = string
  description = "Name of the existing Google Cloud DNS managed zone"
}


variable "Autoscaler_service_account_name" {
  description = "Autoscaler Name of the Service Account"
  type        = string
}

variable "Autoscaler_service_account_display_name" {
  description = "Autoscaler Display Name of the Service Account"
  type        = string
}

variable "it_disk_auto_delete" {
  description = "Whether the boot disk should be automatically deleted when the instance is deleted."
  type        = bool

}

variable "it_disk_boot" {
  description = "Whether this is a boot disk."
  type        = bool
}

variable "it_can_ip_forward" {
  description = "Whether the instance can forward IP packets."
  type        = bool
}

variable "it_template_name" {
  description = "Name for the compute instance template."
  type        = string
}

variable "it_template_description" {
  description = "Description for the compute instance template."
  type        = string
}

variable "it_scopes" {
  description = "List of scopes for the instance. Valid values include 'cloud-platform', 'userinfo-email', 'compute-ro', and 'storage-ro'."
  type        = list(string)
}

variable "health_check_interval_sec" {
  description = "How often (in seconds) to send a health check. The default value is 60 seconds."
  type        = number
}

variable "health_check_timeout_sec" {
  description = "How long (in seconds) to wait before considering the operation as timeout. The default value is 5 seconds."
  type        = number
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health check successes required before considering an unhealthy instance healthy. The default value is 2."
  type        = number
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering an instance unhealthy. The default value is 2."
  type        = number
}

variable "health_check_name" {
  description = "Name for the HTTP health check."
  type        = string
}

variable "health_check_request_path" {
  description = "The path to use for the HTTP health check request."
  type        = string
}

variable "health_check_log_config_enable" {
  description = "Whether logging should be enabled for the health check."
  type        = bool
}

variable "instance_group_manager_name" {
  description = "Name for the instance group manager."
  type        = string
}



variable "base_instance_name" {
  description = "Base name for the instances in the instance group."
  type        = string
  default     = "webapp"
}

variable "igm_base_instance_name" {
  description = "Base name for the instances in the instance group."
  type        = string
}

variable "igm_target_size" {
  description = "The number of instances in the managed instance group."
  type        = number
}

variable "igm_named_port_name" {
  description = "The name of the named port."
  type        = string
}

variable "ignm_named_port_port" {
  description = "The port number of the named port."
  type        = number
}

variable "igm_auto_healing_initial_delay_sec" {
  description = "The initial delay (in seconds) for auto-healing."
  type        = number
}

variable "autoscaler_name" {
  description = "Name for the autoscaler."
  type        = string
}

variable "autoscaler_max_replicas" {
  description = "Maximum number of replicas for the autoscaler."
  type        = number
}

variable "autoscaler_min_replicas" {
  description = "Minimum number of replicas for the autoscaler."
  type        = number
}

variable "autoscaler_cooldown_period" {
  description = "Cooldown period (in seconds) for the autoscaler."
  type        = number
}

variable "autoscaler_target" {
  description = "Target CPU utilization for the autoscaler."
  type        = number
}

variable "name_lb_ipv4_address" {
  description = "The name attribute for the lb-ipv4-address resource"
  type        = string
}

variable "rule_name" {
  description = "The name attribute for the resource"
  type        = string
}

variable "rule_ip_protocol" {
  description = "The IP protocol for the resource"
  type        = string
}

variable "rule_load_balancing_scheme" {
  description = "The load balancing scheme for the resource"
  type        = string
}

variable "rule_port_range" {
  description = "The port range for the resource"
  type        = string
}

variable "https_proxy_name" {
  description = "The name attribute for the resource"
  type        = string
}

variable "url_map_name" {
  description = "The name attribute for the resource"
  type        = string
}

variable "ssl_certificate_name" {
  description = "The name attribute for the resource"
  type        = string
}

variable "webapp_backend_name" {
  description = "The name attribute for the resource"
  type        = string
}

variable "webapp_backend_protocol" {
  description = "The protocol for the resource"
  type        = string
}

variable "webapp_backend_port_name" {
  description = "The port name for the resource"
  type        = string
}

variable "webapp_backend_load_balancing_scheme" {
  description = "The load balancing scheme for the resource"
  type        = string
}

variable "webapp_backend_timeout_sec" {
  description = "The timeout in seconds for the resource"
  type        = number
}

variable "webapp_backend_enable_cdn" {
  description = "Flag to enable CDN for the resource"
  type        = bool
}

variable "webapp_backend_connection_draining_timeout_sec" {
  description = "The connection draining timeout in seconds for the resource"
  type        = number
}

variable "webapp_backend_balancing_mode" {
  description = "The balancing mode for the backend"
  type        = string
}

variable "webapp_backend_capacity_scaler" {
  description = "The capacity scaler for the backend"
  type        = number
}

variable "peering_network_name" {
  description = "The name of the network"
  type        = string
}

variable "peering_auto_create_subnetworks" {
  description = "Whether to enable auto-creation of subnetworks"
  type        = bool
}

variable "webapp_route_priority" {
  description = "The priority of the resource"
  type        = number
}

variable "allow_webapplication_port_name" {
  description = "The name of the VPC"
  type        = string
}

variable "deny_ssh_port_name" {
  description = "The name of the VPC"
  type        = string
}

variable "private_ip_address_name" {
  description = "The name of the IP address resource"
  type        = string
}

variable "private_ip_address_purpose" {
  description = "The purpose of the IP address resource"
  type        = string
}

variable "private_ip_address_type" {
  description = "The type of the IP address resource"
  type        = string
}

variable "private_ip_prefix_length" {
  description = "The prefix length of the IP address resource"
  type        = number
}

variable "deny_ssh_ports" {
  description = "List of allowed ports"
  type        = list(string)
}

variable "deny_ssh_source_ranges" {
  description = "List of allowed source IP ranges"
  type        = list(string)
}

variable "vpc_connector_name" {
  description = "The name of the VPC connector"
  type        = string
}

variable "vpc_connector_ip_cidr_range" {
  description = "The IP CIDR range for the VPC connector"
  type        = string
}

variable "target_pools_name" {
  description = "The name of the Target Pools."
  type        = string
}

variable "locality_lb_policy_name" {
  description = "The load balancing algorithm used within the scope of the locality."
  type        = string
}

variable "compute_service_account_id" {
  type        = string
  description = "The ID of the service account"
}

variable "compute_service_display_name" {
  type        = string
  description = "The display name of the service account"
}

variable "allow_http_name" {
  description = "Name of the resource. Provided by the client when the resource is created"
  type        = string
}

variable "allow_http_direction" {
  description = "Direction of traffic to which this firewall applies; default is INGRESS."
  type        = string
}

variable "allow_http_protocol" {
  type        = string
  description = "The protocol to allow traffic for"
}

variable "allow_http_ports" {
  type        = list(string)
  description = "The list of ports to allow traffic for"
}

variable "allow_http_source_ranges" {
  type        = list(string)
  description = "The list of source IP ranges to allow traffic from"
}

variable "default_name" {
  description = "Name of the resource. Provided by the client when the resource is created"
  type        = string
}

variable "allow_lb_name" {
  description = "Name of the resource. Provided by the client when the resource is created"
  type        = string
}

variable "private_ip_address_service" {
  description = "The name of the service"
  type        = string
}

variable "db_name_byte_length" {
  description = "The length of the byte"
  type        = number
}

variable "enable_private_path_for_google_cloud_services" {
  description = "Enable private access for Google Cloud services"
  type        = bool
}

variable "mysql_ports" {
  description = "List of MySQL ports"
  type        = list(number)
}

variable "firewall_allow_sql_name" {
  description = "Name of the firewall rule to allow SQL access"
  type        = string
}

variable "firewall_allow_web_sql_name" {
  description = "Name of the firewall rule to allow SQL access"
  type        = string
}

variable "bucket_force_destroy" {
  description = "Indicates whether to perform a force destroy of the resource"
  type        = bool
}

variable "instance_template_reservation_type" {
  description = "Type of reservation"
  type        = string
  default     = "NO_RESERVATION"
}

variable "ring_name" {
  type        = string
  description = "Ring Name"
}

variable "SQL_Key_Name" {
  type        = string
  description = "SQL key Name"
}

variable "rotation_period" {
  type = string
}

variable "Cloud_Storage_Key_Name" {
  type        = string
  description = "SQL key Name"
}

variable "Cloud_VM_Key_Name" {
  type        = string
  description = "SQL key Name"
}

variable "MAILGUN_apiKey" {
  description = "API key for the Mailgun service"
  type        = string
}

variable "MAILGUN_domain" {
  description = "Domain for the Mailgun service"
  type        = string
}

# variables.tf

# Name of the rule
variable "allow_https_name" {
  description = "Name of the networking rule"
  type        = string
}

# Direction (ingress or egress)
variable "allow_https_direction" {
  description = "Direction of the rule (ingress or egress)"
  type        = string
}

# Protocol (e.g., tcp, udp)
variable "allow_https_protocol" {
  description = "Protocol allowed by the rule"
  type        = string
}

# Ports allowed
variable "allow_https_ports" {
  description = "Specific ports allowed by the rule"
  type        = list(number)
}

# Source IP ranges
variable "allow_https_source_ranges" {
  description = "Source IP ranges for the rule"
  type        = list(string)
}

