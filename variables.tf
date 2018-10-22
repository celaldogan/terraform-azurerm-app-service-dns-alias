variable "count_of_app_service_names" {
  default     = 1
  description = "Count must be of equal length to app_service_names lists"
}

variable "app_service_names" {
  type = "list"
}

variable "dns_zone" {
  type = "string"
}

variable "app_service_resource_group_name" {}

variable "ttl" {
  default = 300
}
