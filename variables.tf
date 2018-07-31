variable "count" {
  default     = 1
  description = "Count must be of equal length to dns_name and alias lists"
}

variable "app_service_names" {
  type = "list"
}

variable "fqdn_aliases" {
  type = "list"
}

variable "dns_zone" {
  type = "string"
}

variable "dns_zone_resource_group_name" {}
variable "app_service_resource_group_name" {}

variable "ttl" {
  default = 300
}

locals {
  dns_zone = "${var.dns_zone_provider == "" ? "default" : var.dns_zone_provider}"
}
