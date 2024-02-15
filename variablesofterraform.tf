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