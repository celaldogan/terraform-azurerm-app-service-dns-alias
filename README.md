# terraform-azurerm-app-service-dns-alias

Terraform module designed to creates DNS alias (CNAME) for an existing Azure App Service, web or function.

## Usage

### Sample
Include this repository as a module in your existing terraform code:

```hcl

data "azurerm_dns_zone" "test" {
  name                = "example.com"
  resource_group_name = "testing-service-rg"
  provider = "azurerm.could-be-other-provider"
}

module "eg_add_fqdn_alias" {
  source     = "git::https://github.com/transactiveltd/tf-module-azure-arm-certificate.git?ref=master"
  count_of_app_services = 1

  dns_zone                         = "${data.azurerm_dns_zone.test.name}"
  dns_zone_resource_group_name     = "${data.azurerm_dns_zone.test.resource_group_name}"
  fqdn_aliases                     = "${list("someother.domain.com","another.domain.com")}"
  app_service_names                = "${list("app-someother","app-another")}"
  app_service_resource_group_name  = "app-service-rg"
  ttl                              = 300
}
```

This will run will add Alias for each Domain (App Service Name) on the specified DNS Zone in azure for the given resource group.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| count_of_app_services | Count, Count must be of equal length to dns_name and alias lists | number | - | yes |
| dns_zone | DNS Zone to add the list of domains, e.g. `example.com` | string | - | yes |
| dns_zone_resource_group_name | Azure Resource Group where the dns_zone is located, e.g. `dns-zone-rg` | string | - | yes |
| fqdn_aliases | List of FQDN alias one for each `app_service_names` the length of the lists and the count must all equal. | list| - | yes |
| app_service_names | List of app_service_names to add to the dns zone; one for each `fqdn_aliases` the length of the lists and the count must all equal.| list | - | yes |
| app_service_resource_group_name | Resource Group name, e.g. `testing-service-rg` | string | - | yes |
| ttl | Ttl Time-To-Live setting in seconds, e.g. `300` | string | '300' | yes |


## Outputs

| Name | Description |
|------|-------------|
| fqdn | list of FQDNs |
| app_services | comma delimeted string of app services |
