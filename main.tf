resource "azurerm_dns_cname_record" "default" {
  count               = "${var.count_of_app_services}"
  name                = "${element(var.app_service_names, count.index)}"
  zone_name           = "${var.dns_zone}"
  resource_group_name = "${var.dns_zone_resource_group_name}"
  ttl                 = "${var.ttl}"
  record              = "${element(var.fqdn_aliases, count.index)}"
  provider            = "azurerm.prod-global-services"
}

resource "azurerm_app_service_custom_hostname_binding" "default" {
  count               = "${var.count_of_app_services}"
  hostname            = "${format("%s.%s", element(azurerm_dns_cname_record.default.*.name, count.index), element(azurerm_dns_cname_record.default.*.zone_name, count.index)) }"
  app_service_name    = "${element(var.app_service_names, count.index)}"
  resource_group_name = "${var.app_service_resource_group_name}"
}
