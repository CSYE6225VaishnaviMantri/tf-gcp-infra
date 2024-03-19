
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
