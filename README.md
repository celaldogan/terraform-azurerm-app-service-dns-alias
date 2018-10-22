# terraform-azurerm-app-service-dns-alias

Terraform module designed to creates DNS alias (CNAME) for an existing Azure App Service, web or function.

#### Providers, Resources and Modules:
| Name | Description |Type|Version|
|------|-------------|:---:|:---:|
|`azurearm`| alias provider required `azurerm.dns` |provider|-|
|`azurerm_app_service`|Data|data source|-|
|`azurerm_dns_cname_record`|DNS CNAME for each custom hostname to the app service default host name|resource|-|
|`azurerm_app_service_custom_hostname_binding`| Add custom domain names |resource|-|
## Usage

### Sample
Include this repository as a module in your existing terraform code:

```hcl
data "azurerm_dns_zone" "test" {
  name                = "example.com"
}

data "azurerm_app_service" "test" {
  name                = "app-service"
  resource_group_name = "app-service-rg"
}

module "eg_add_fqdn_alias" {
  source     = "git::https://github.com/transactiveltd/tf-module-azure-arm-certificate.git?ref=master"
  count_of_app_services = 1

  dns_zone_name                    = "${data.azurerm_dns_zone.test.name}"
  app_service_names                = "${data.azurerm_app_service.test.*.name[count.index]}"
  app_service_resource_group_name  = "app-service-rg"
  ttl                              = 300

  providers = {
    azurerm.dns = "azurerm.some-alias"
  }
}
```

This will run will add Alias for each Domain (App Service Name) on the specified DNS Zone in azure for the given resource group.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| count_of_app_services | Count, Count must be of equal length to dns_name and alias lists | number | - | yes |
| dns_zone_name | DNS Zone to add the list of domains, e.g. `example.com` | string | - | yes |
| app_service_names | List of app_service_names to add to the dns zone; the length of the lists and the count must all equal.| list | - | yes |
| app_service_resource_group_name | Resource Group name, e.g. `testing-service-rg` | string | - | yes |
| ttl | Ttl Time-To-Live setting in seconds, e.g. `300` | string | '300' | yes |


## Outputs

| Name | Description |
|------|-------------|
| fqdn | list of FQDNs |
| app_services | comma delimeted string of app services |
