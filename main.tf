# ---------------------------------------------------------------------------------------------------------------------
# Provider
# ---------------------------------------------------------------------------------------------------------------------
provider "azurerm" {}

provider "azurerm" {
  alias = "dns"
}

# ---------------------------------------------------------------------------------------------------------------------
# Data
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_app_service" "default" {
  count               = "${var.count_of_app_service_names}"
  name                = "${element(var.app_service_names, count.index)}"
  resource_group_name = "${var.app_service_resource_group_name}"
}

data "azurerm_dns_zone" "default" {
  name     = "${var.zone_name}"
  provider = "azurerm.dns"
}

# ---------------------------------------------------------------------------------------------------------------------
# DNS CNAMES
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_dns_cname_record" "default" {
  count               = "${var.count_of_app_service_names}"
  name                = "${data.azurerm_app_service.default.*.name[count.index]}"
  zone_name           = "${data.azurerm_dns_zone.default.name}"
  resource_group_name = "${data.azurerm_dns_zone.default.resource_group_name}"
  ttl                 = "${var.ttl}"
  record              = "${data.azurerm_app_service.default.*.default_site_hostname[count.index]}"
  provider            = "azurerm.dns"
}

resource "azurerm_app_service_custom_hostname_binding" "default" {
  count               = "${var.count_of_app_service_names}"
  hostname            = "${format("%s.%s",azurerm_dns_cname_record.default.*.name[count.index], azurerm_dns_cname_record.default.*.zone_name[count.index]) }"
  app_service_name    = "${data.azurerm_app_service.default.*.name[count.index]}"
  resource_group_name = "${data.azurerm_app_service.default.*.resource_group_name[count.index]}"
}
