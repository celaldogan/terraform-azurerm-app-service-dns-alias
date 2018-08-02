output "fqdn" {
  value = "${azurerm_app_service_custom_hostname_binding.default.*.hostname}"
}

output "app_service_names" {
  value = "${azurerm_app_service_custom_hostname_binding.default.*.app_service_name}"
}

output "app_service_alias" {
  value = "${zipmap(azurerm_app_service_custom_hostname_binding.default.*.app_service_name,azurerm_app_service_custom_hostname_binding.default.*.hostname)}"
}
