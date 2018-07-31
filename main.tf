data "azurerm_dns_zone" "dns_zone" {
  name                = "${var.dns_zone}"
  resource_group_name = "${var.dns_zone_resource_group_name}"
  provider            = "azurerm.prod-global-services"
}

data "azurerm_resource_group" "app_service" {
  name = "${var.app_service_resource_group_name}"
}

resource "azurerm_dns_cname_record" "default" {
  count               = "${var.count}"
  name                = "${element(var.app_service_names, count.index)}"
  zone_name           = "${data.azurerm_dns_zone.dns_zone.name}"
  resource_group_name = "${data.azurerm_dns_zone.dns_zone.resource_group_name}"
  ttl                 = "${var.ttl}"
  record              = "${element(var.fqdn_aliases, count.index)}"
  provider            = "azurerm.prod-global-services"
}

resource "azurerm_app_service_custom_hostname_binding" "default" {
  count               = "${var.count}"
  dns_name            = "${format("%s.%s", element(azurerm_dns_cname_record.default.*.name, count.index), element(azurerm_dns_cname_record.default.*.zone_name, count.index)) }"
  app_service_name    = "${element(var.app_service_names, count.index)}"
  resource_group_name = "${data.azurerm_resource_group.app_service.name}"
}
