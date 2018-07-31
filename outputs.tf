output "fqdn" {
  value = "${join(",",azurerm_app_service_custom_hostname_binding.default.*.hostname)}"
}

output "app_service_names" {
  value = "${join(",",azurerm_app_service_custom_hostname_binding.default.*.app_service_name)}"
}
