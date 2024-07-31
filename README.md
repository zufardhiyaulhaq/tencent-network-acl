## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | 1.81.111 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | 1.81.111 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_vpc_acl.application](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl) | resource |
| [tencentcloud_vpc_acl.compliance](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl) | resource |
| [tencentcloud_vpc_acl.public](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl) | resource |
| [tencentcloud_vpc_acl.stateful](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl) | resource |
| [tencentcloud_vpc_acl.utility](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl) | resource |
| [tencentcloud_vpc_acl_attachment.application](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl_attachment) | resource |
| [tencentcloud_vpc_acl_attachment.compliance](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl_attachment) | resource |
| [tencentcloud_vpc_acl_attachment.public](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl_attachment) | resource |
| [tencentcloud_vpc_acl_attachment.stateful](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl_attachment) | resource |
| [tencentcloud_vpc_acl_attachment.utility](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/1.81.111/docs/resources/vpc_acl_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ingress_application_rules"></a> [additional\_ingress\_application\_rules](#input\_additional\_ingress\_application\_rules) | List of additional ingress rules for application network ACL | `list(string)` | `[]` | no |
| <a name="input_additional_ingress_compliance_rules"></a> [additional\_ingress\_compliance\_rules](#input\_additional\_ingress\_compliance\_rules) | List of additional ingress rules for compliance network ACL | `list(string)` | `[]` | no |
| <a name="input_additional_ingress_public_rules"></a> [additional\_ingress\_public\_rules](#input\_additional\_ingress\_public\_rules) | List of additional ingress rules for public network ACL | `list(string)` | `[]` | no |
| <a name="input_additional_ingress_stateful_rules"></a> [additional\_ingress\_stateful\_rules](#input\_additional\_ingress\_stateful\_rules) | List of additional ingress rules for stateful network ACL | `list(string)` | `[]` | no |
| <a name="input_additional_ingress_utility_rules"></a> [additional\_ingress\_utility\_rules](#input\_additional\_ingress\_utility\_rules) | List of additional ingress rules for utility network ACL | `list(string)` | `[]` | no |
| <a name="input_application_subnets_cidr"></a> [application\_subnets\_cidr](#input\_application\_subnets\_cidr) | List of application subnets CIDR | `list(string)` | n/a | yes |
| <a name="input_application_subnets_id"></a> [application\_subnets\_id](#input\_application\_subnets\_id) | List of application subnets ID | `list(string)` | n/a | yes |
| <a name="input_compliance_subnets_cidr"></a> [compliance\_subnets\_cidr](#input\_compliance\_subnets\_cidr) | List of compliance subnets CIDR | `list(string)` | n/a | yes |
| <a name="input_compliance_subnets_id"></a> [compliance\_subnets\_id](#input\_compliance\_subnets\_id) | List of compliance subnets ID | `list(string)` | n/a | yes |
| <a name="input_label_environment"></a> [label\_environment](#input\_label\_environment) | Enviroment label | `string` | n/a | yes |
| <a name="input_label_team"></a> [label\_team](#input\_label\_team) | Team label | `string` | n/a | yes |
| <a name="input_public_subnets_cidr"></a> [public\_subnets\_cidr](#input\_public\_subnets\_cidr) | List of public subnets CIDR | `list(string)` | n/a | yes |
| <a name="input_public_subnets_id"></a> [public\_subnets\_id](#input\_public\_subnets\_id) | List of public subnets ID | `list(string)` | n/a | yes |
| <a name="input_stateful_subnets_cidr"></a> [stateful\_subnets\_cidr](#input\_stateful\_subnets\_cidr) | List of stateful subnets CIDR | `list(string)` | n/a | yes |
| <a name="input_stateful_subnets_id"></a> [stateful\_subnets\_id](#input\_stateful\_subnets\_id) | List of stateful subnets ID | `list(string)` | n/a | yes |
| <a name="input_utility_subnets_cidr"></a> [utility\_subnets\_cidr](#input\_utility\_subnets\_cidr) | List of utility subnets CIDR | `list(string)` | n/a | yes |
| <a name="input_utility_subnets_id"></a> [utility\_subnets\_id](#input\_utility\_subnets\_id) | List of utility subnets ID | `list(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |

## Outputs

No outputs.
